from csv_reader import CSVReader
from database import Database
from directly_follows import DirectlyFollowsMetric
from heuristic_miner import HeuristicMiner
from log_processor import LogProcessor
from predictor import Predictor
from time_distance_median import TimeDistanceMedian
from time_distance_stdev import TimeDistanceStdev

class AbstractionControl():
    
    def __init__(self) -> None:
        self.csv_reader = CSVReader()
        self.database = Database(5, 0, 3, "bolt://localhost:7687", "neo4j", "password")
        self.metrics = []
        self.predictor = None
        self.log_processor = None
        self.heuristic_miner = None
        self.level_of_abstraction = 0
        self.pair_we_are_at = 0
        self.sorted_pair_array = []
        self.sorted_pair_labels = []

        self.setUp()


    def setUp(self):
        data = self.csv_reader.read_data(
            "Data.csv", "%Y-%m-%dT%H:%M:%S.%f",  6, 8114, ";", 3, 26)
        self.database.update_latest_log(data)
        self.database.initiate_tree()
        self.log_processor = LogProcessor(self.database)
        self.log_processor.delete_repetitions()
        self.heuristic_miner = HeuristicMiner(self.database)
        self.add_metrics()
        self.predictor = Predictor(self.metrics, self.database)
        self.heuristic_miner.save_process_as_png(0)
        print("Saving Process Model Abstraction 0")
        self.get_new_prediction()


    def get_new_prediction(self):
        self.predictor.predict_sum()
        self.sorted_pair_array, self.sorted_pair_labels = self.predictor.sort_results()
        self.redefine_e1_e2()
        
    def yes(self):
        self.level_of_abstraction += 1
        nr_events_abstracted = self.log_processor.abstract_log(self.e1, self.e2, self.e1 +self.e2)
        self.log_processor.delete_repetitions()

        print("Abstracted {} Events".format(nr_events_abstracted))
        print(
            f"Now you only have {len(self.database.get_actions())} actions")
        print(
            f"{self.database.events_deleted_last_abstraction} have been deleted")

        self.database.update_tree(self.e1, self.e2, self.e1+self.e2)
        self.heuristic_miner.save_process_as_png(self.level_of_abstraction)
        self.get_new_prediction()
        self.pair_we_are_at = 0
        
    def no(self):
        self.pair_we_are_at += 1
        self.redefine_e1_e2()

    def redefine_e1_e2(self):
        set_of_actions = self.database.get_actions()
        self.e1 = set_of_actions[self.sorted_pair_labels[0, self.pair_we_are_at]]
        self.e2 = set_of_actions[self.sorted_pair_labels[1, self.pair_we_are_at]]

    def get_message(self):
        return f"Do you want to abstract:{self.e1} AND {self.e2} \n The time distance between them is: {self.sorted_pair_array[self.pair_we_are_at]}"

    def add_metrics(self):
        time_distance_stdev = TimeDistanceStdev(self.database)
        time_distance_median = TimeDistanceMedian(self.database)
        directly_follows = DirectlyFollowsMetric(self.database, False)
        self.metrics = [directly_follows, time_distance_median, time_distance_stdev]

    """
    data = csv_reader.read_data(
            "C:\\Users\\39327\\Downloads\\BPI2016_Clicks_NOT_Logged_In.csv", "%Y-%m-%d %H:%M:%S", 5, 10000, ";", 2, 18)
        # Store data on database
        database = Database(
            4, 1, 2, "bolt://localhost:7687", "neo4j", "password")
    """
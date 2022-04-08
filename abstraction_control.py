from csv_reader import CSVReader
from database import Database
from directly_follows import DirectlyFollowsMetric
from heuristic_miner import HeuristicMiner
from log_processor import LogProcessor
from predictor import Predictor
from time_distance_median import TimeDistanceMedian
from time_distance_stdev import TimeDistanceStdev
from PySide6.QtCore import QThread


class AbstractionControl():

    def __init__(self) -> None:
        self.csv_reader = CSVReader()
        self.database = Database(
            5, 0, 3, "bolt://localhost:7687", "neo4j", "password")
        self.metrics = []
        self.predictor = None
        self.log_processor = None
        self.heuristic_miner = None
        #self.level_of_abstraction = 0
        self.pair_we_are_at = 0
        self.sorted_pair_array = []
        self.sorted_pair_labels = []

        self.setUp()

    def setUp(self):
        self.database.increase_level_of_abstraction()
        data = self.csv_reader.read_data(
            "Data.csv", "%Y-%m-%dT%H:%M:%S.%f",  6, 8114, ";", 3, 26, False)
        self.database.update_latest_log(data)
        #self.database.initiate_tree()
        self.log_processor = LogProcessor(self.database)
        self.log_processor.delete_repetitions()
        self.heuristic_miner = HeuristicMiner(self.database)
        self.add_metrics()
        self.predictor = Predictor(self.metrics, self.database)
        self.heuristic_miner.save_process_as_png(
            self.database.level_of_abstraction)
        self.database.init_abstraction_tree_string()
        self.database.generate_tree()
        print(
            f"Saving Process Model Abstraction {self.database.level_of_abstraction}")
        self.get_new_prediction()

    def reset(self):
        filename = f"abstractions/Abstraction{self.database.level_of_abstraction}.csv"
        data = self.csv_reader.read_data(
            filename, "%S.%f",  6, 8114, ",", 3, 26, True)
        self.database.reset(data)

    def get_new_prediction(self):
        self.predictor.predict_sum()
        self.sorted_pair_array, self.sorted_pair_labels = self.predictor.sort_results()

    def abstract(self):
        self.database.increase_level_of_abstraction()
        set_of_actions = self.database.get_actions()

        e1 = set_of_actions[self.sorted_pair_labels[0, self.pair_we_are_at]]
        e2 = set_of_actions[self.sorted_pair_labels[1, self.pair_we_are_at]]
        nr_events_abstracted = self.log_processor.abstract_log(e1, e2, e1 + e2)
        self.log_processor.delete_repetitions()
        self.database.update_latest_log(self.database.latest_log)

        print(f"Merging {e1} and {e2}")
        print(f"Abstracted {nr_events_abstracted} Events")
        print(f"Now you only have {len(self.database.get_actions())} actions")
        print(f"{self.database.events_deleted_last_abstraction} have been deleted")

        self.database.update_tree(e1, e2, e1 + e2)
        self.heuristic_miner.save_process_as_png(
            self.database.level_of_abstraction)
        self.get_new_prediction()
        self.pair_we_are_at = 0

    def get_sorted_pair_labels(self):
        set_of_actions = self.database.get_actions()
        return [(set_of_actions[self.sorted_pair_labels[0, n]], set_of_actions[self.sorted_pair_labels[1, n]]) for n in range(len(self.sorted_pair_labels[0, :]))]

    def add_metrics(self):
        time_distance_stdev = TimeDistanceStdev(self.database)
        time_distance_median = TimeDistanceMedian(self.database)
        directly_follows = DirectlyFollowsMetric(self.database, False)
        self.metrics = [directly_follows,
                        time_distance_median, time_distance_stdev]

    def set_pair_we_are_at(self, i):
        self.pair_we_are_at = i

    def change_hyperparameters(self, metricslist):
        print(metricslist)
        for metric in metricslist:
            for name in metric:
                self.predictor.change_hyperparameter(name, metric[name])

    """
    data = csv_reader.read_data(
            "C:\\Users\\39327\\Downloads\\BPI2016_Clicks_NOT_Logged_In.csv", "%Y-%m-%d %H:%M:%S", 5, 10000, ";", 2, 18)
        # Store data on database
        database = Database(
            4, 1, 2, "bolt://localhost:7687", "neo4j", "password")
    """

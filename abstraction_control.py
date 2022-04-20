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

    def __init__(self, filename, time_string, number_columns, number_rows, separator, timestamp_column, number_chars_timestamp, inseconds, action_column, trace_column) -> None:
        self.csv_reader = CSVReader()
        # , "bolt://localhost:7687", "neo4j", "password")
        self.database = Database(action_column, trace_column, timestamp_column)
        self.metrics = []
        self.predictor = None
        self.log_processor = None
        self.heuristic_miner = None
        #self.level_of_abstraction = 0
        self.pair_we_are_at = 0
        self.sorted_pair_array = [[]]
        self.sorted_pair_labels = [[]]
        self.setUp(filename, time_string, number_columns, number_rows,
                   separator, timestamp_column, number_chars_timestamp, inseconds)

    def setUp(self, filename, time_string, number_columns, number_rows, separator, timestamp_column, number_chars_timestamp, inseconds):
        self.database.increase_level_of_abstraction()
        data = self.csv_reader.read_data(filename, time_string, number_columns,
                                         number_rows, separator, timestamp_column, number_chars_timestamp, inseconds)
        self.database.update_latest_log(data)
        # self.database.initiate_tree()
        self.log_processor = LogProcessor(self.database)
        #self.log_processor.delete_repetitions()
        self.heuristic_miner = HeuristicMiner(self.database)
        self.add_metrics()
        self.predictor = Predictor(self.metrics, self.database)
        self.heuristic_miner.save_process_as_png(
            self.database.level_of_abstraction[self.database.currenttab])
        self.database.init_abstraction_tree_string()
        self.database.generate_tree()
        print(
            f"Saving Process Model Abstraction {self.database.level_of_abstraction}")
        self.get_new_prediction()

    def reset(self):
        filename = f"tab{self.database.currenttab}/abstractions/Abstraction{self.database.level_of_abstraction[self.database.currenttab]}.csv"
        data = self.csv_reader.read_data(
            filename, "%S.%f",  6, 8114, ",", 3, 26, True)
        self.database.reset(data)

    def get_new_prediction(self):
        self.predictor.predict_sum()
        self.sorted_pair_array[self.database.currenttab], self.sorted_pair_labels[
            self.database.currenttab] = self.predictor.sort_results()

    def abstract(self):
        print("init Abstract")
        self.database.increase_level_of_abstraction()
        set_of_actions = self.database.get_actions()
        e1 = set_of_actions[self.sorted_pair_labels[self.database.currenttab]
                            [0, self.pair_we_are_at]]
        e2 = set_of_actions[self.sorted_pair_labels[self.database.currenttab]
                            [1, self.pair_we_are_at]]
        print("renaming")
        nr_events_abstracted = self.log_processor.abstract_log(e1, e2, e1 + e2)
        # print("1")
        print("seleting repetitions")
        # self.log_processor.delete_repetitions()
        # print("2")
        print("updating_latest_log")
        self.database.update_latest_log(
            self.database.latest_log[self.database.currenttab])

        #print(f"Merging {e1} and {e2}")
        #print(f"Abstracted {nr_events_abstracted} Events")
        #print(f"Now you only have {len(self.database.get_actions())} actions")
        #print(f"{self.database.events_deleted_last_abstraction} have been deleted")

        self.database.update_tree(e1, e2, e1 + e2)
        # print("3")
        self.heuristic_miner.save_process_as_png(
            self.database.level_of_abstraction[self.database.currenttab])
        # print("3")
        self.get_new_prediction()
        # print("3")
        self.pair_we_are_at = 0

    def delete_repetitions_specific_event(self, action_index):
        set_of_actions = self.database.get_actions()
        event = set_of_actions[action_index]
        print("Delete Repetitions for " + event)
        self.database.increase_level_of_abstraction()
        
        self.log_processor.delete_repetitions_event(event)
        self.database.update_latest_log(
            self.database.latest_log[self.database.currenttab])
        self.database.generate_tree_no_change()
        self.heuristic_miner.save_process_as_png(
            self.database.level_of_abstraction[self.database.currenttab])
        self.get_new_prediction()
        self.pair_we_are_at = 0


    def delete_all_repetitions(self):
        print("Delete Repetitions for all events ")
        self.database.increase_level_of_abstraction()
        
        self.log_processor.delete_repetitions()
        self.database.update_latest_log(
            self.database.latest_log[self.database.currenttab])
        self.database.generate_tree_no_change()
        self.heuristic_miner.save_process_as_png(
            self.database.level_of_abstraction[self.database.currenttab])
        self.get_new_prediction()
        self.pair_we_are_at = 0

    def get_sorted_pair_labels(self):
        set_of_actions = self.database.get_actions()
        candidates = []
        for n in range(len(self.sorted_pair_labels[self.database.currenttab][0][:])):
            metrics_string = ""
            for m, metric in enumerate(self.metrics):
                metrics_string = metrics_string + metric.get_nikname() + f": {round(self.sorted_pair_array[self.database.currenttab][m][n], 3)} "
            candidate = (set_of_actions[self.sorted_pair_labels[self.database.currenttab][0][n]], set_of_actions[self.sorted_pair_labels[self.database.currenttab][1][n]], metrics_string)
            
            candidates.append(candidate)
        return candidates

    def add_metrics(self):
        time_distance_stdev = TimeDistanceStdev(self.database)
        time_distance_median = TimeDistanceMedian(self.database)
        directly_follows = DirectlyFollowsMetric(self.database, False)
        directly_follows_2 = DirectlyFollowsMetric(self.database, True)
        self.metrics = [directly_follows,
                        time_distance_median, time_distance_stdev, directly_follows_2]

    def get_metrics_list(self):
        metrics_list = []
        for metric in self.metrics:
            metrics_list.append((metric.get_name(), self.predictor.hyperparameters[metric.get_name()]))
        return metrics_list

    def set_pair_we_are_at(self, i):
        self.pair_we_are_at = i

    def change_hyperparameters(self, metricslist):
        # print(metricslist)
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

    def swap_candidates(self, tab):
        return self.sorted_pair_array[tab], self.sorted_pair_array[tab]

    def newTab(self, tab):
        print("here tab " + str(tab))
        self.sorted_pair_array.append(self.sorted_pair_array[0])
        self.sorted_pair_labels.append(self.sorted_pair_labels[0])
        self.database.newTab(tab)

    def deletetab(self, tab):
        self.sorted_pair_array.pop(tab)
        self.sorted_pair_labels.pop(tab)
        self.database.deletetab(tab)

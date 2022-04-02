from curses import pair_content
import tkinter as tk
from csv_reader import CSVReader
from database import Database
from log_processor import LogProcessor
from predictor import Predictor
from time_distance_median import TimeDistanceMedian
from time_distance_stdev import TimeDistanceStdev
from heuristic_miner import HeuristicMiner
from directly_follows import DirectlyFollowsMetric
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtQuick import QQuickWindow
from PyQt6.QtCore import QObject, pyqtSignal, pyqtSlot
import sys
import time


def ask_user(event1, event2, distance):
    print("Do you want to abstract:")
    print(event1 + " AND " + event2)
    print("The time distance between them is:")
    print(distance)
    return input(" Type Yes or No or Stop")


class Backend(QObject):
    def __init__(self):
        QObject.__init__(self)

    updated = pyqtSignal(str, arguments=['updater'])

    def updater(self, nextmerge):
        self.updated.emit(nextmerge)


class Button_Yes(QObject):
    def __init__(self, response):
        QObject.__init__(self)
        self.respose = response

    @pyqtSlot()
    def yes(self):
        response.yes()


class Button_No(QObject):
    def __init__(self, response):
        QObject.__init__(self)
        self.respose = response

    @pyqtSlot()
    def no(self):
        response.no()


class Response:
    def __init__(self, backend):
        self.backend = backend

    def yes(self):
        global level_of_abstraction
        global sorted_pair_array
        global sorted_pair_labels
        global pair_we_are_at
        global e1, e2

        self.backend.updater("Loading..")

        time.sleep(2)
        nr_events_abstracted = log_processor.abstract_log(
            e1, e2, e1+e2)
        log_processor.delete_repetitions()
        #rawdata, nr_events_abstracted, set_of_actions = abstract_log(e1, e2, e1 + e2, rawdata)

        print("Abstracted {} Events".format(nr_events_abstracted))
        print(
            f"Now you only have {len(database.get_actions())} actions")
        print(
            f"{database.events_deleted_last_abstraction} have been deleted")

        database.update_tree(e1, e2, e1+e2)
        heuristic_miner.save_process_as_png(level_of_abstraction)
        predictor.predict_sum()
        sorted_pair_array, sorted_pair_labels = predictor.sort_results()
        level_of_abstraction += 1
        pair_we_are_at = 0

        set_of_actions = database.get_actions()
        e1 = set_of_actions[sorted_pair_labels[0, pair_we_are_at]]
        e2 = set_of_actions[sorted_pair_labels[1, pair_we_are_at]]

        self.backend.updater(
            f"Do you want to abstract:{e1} AND {e2} \n The time distance between them is: {sorted_pair_array[pair_we_are_at]}")

    def no(self):
        global pair_we_are_at
        global set_of_actions
        global e1, e2
        pair_we_are_at += 1
        e1 = set_of_actions[sorted_pair_labels[0, pair_we_are_at]]
        e2 = set_of_actions[sorted_pair_labels[1, pair_we_are_at]]
        self.backend.updater(
            f"Do you want to abstract:{e1} AND {e2} \n The time distance between them is: {sorted_pair_array[pair_we_are_at]}")


if __name__ == "__main__":

    #Read in csv
    first_log = True
    csv_reader = CSVReader()
    if first_log:
        data = csv_reader.read_data(
            "Data.csv", "%Y-%m-%dT%H:%M:%S.%f",  6, 8114, ";", 3, 26)
        # Store data on database
        database = Database(
            5, 0, 3, "bolt://localhost:7687", "neo4j", "password")
    else:
        data = csv_reader.read_data(
            "C:\\Users\\39327\\Downloads\\BPI2016_Clicks_NOT_Logged_In.csv", "%Y-%m-%d %H:%M:%S", 5, 10000, ";", 2, 18)
        # Store data on database
        database = Database(
            4, 1, 2, "bolt://localhost:7687", "neo4j", "password")

    database.update_latest_log(data)
    database.initiate_tree()
    # Delete repetitions
    log_processor = LogProcessor(database)
    log_processor.delete_repetitions()
    # Initiate Metrics and predictor
    time_distance_stdev = TimeDistanceStdev(database)
    time_distance_median = TimeDistanceMedian(database)
    directly_follows = DirectlyFollowsMetric(database, False)
    metrics = [directly_follows, time_distance_median, time_distance_stdev]
    predictor = Predictor(metrics, database)

    # Initiate Heuristic Miner
    heuristic_miner = HeuristicMiner(database)
    heuristic_miner.save_process_as_png(0)
    print("Initial actions:" + str(len(database.get_actions())))

    level_of_abstraction = 1
    pair_we_are_at = 0
    predictor.predict_sum()
    sorted_pair_array, sorted_pair_labels = predictor.sort_results()
    set_of_actions = database.get_actions()
    e1 = set_of_actions[sorted_pair_labels[0, pair_we_are_at]]
    e2 = set_of_actions[sorted_pair_labels[1, pair_we_are_at]]

    QQuickWindow.setSceneGraphBackend('software')
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.quit.connect(app.quit)
    engine.load('./UI/main.qml')

    backend = Backend()
    response = Response(backend)
    button_yes = Button_Yes(response)
    button_no = Button_No(response)
    engine.rootObjects()[0].setProperty('button_yes', button_yes)
    engine.rootObjects()[0].setProperty('button_no', button_no)
    engine.rootObjects()[0].setProperty('backend', backend)
    backend.updater(
        f"Do you want to abstract:{e1} AND {e2} \n The time distance between them is: {sorted_pair_array[pair_we_are_at]}")

    sys.exit(app.exec())

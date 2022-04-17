from hashlib import new
from abstraction_control import AbstractionControl
from abstraction_worker import AbstractionWorker, UpdateCandidatesWorker
from PySide6.QtCore import Slot, QObject, QThread, Signal

from database import Database


class CandidateController(QObject):

    def __init__(self) -> None:
        super().__init__()
        self.abstraction_controller = None
        self.thread = None
        self.worker = None
        self.thread2 = None
        self.worker2 = None
        self.hyperparams = [None]

    updated = Signal(list, int, str, int)

    tabchanged = Signal(int)

    metricschanged = Signal(list, int)

    @Slot(str, str, int, int, str, int, int, bool, int, int)
    def init_abstraction_controller(self, filename, time_string, number_columns, number_rows, separator, timestamp_column, number_chars_timestamp, inseconds, action_column, trace_column):
        self.abstraction_controller = AbstractionControl(filename, time_string, number_columns, number_rows, separator, timestamp_column, number_chars_timestamp, inseconds, action_column, trace_column)

    @Slot()
    def get_metrics(self):
        metrics_list = self.abstraction_controller.get_metrics_list()
        self.metricschanged.emit(metrics_list, len(metrics_list) - 1)

    @Slot(str, float)
    def change_hyperparameter(self, name, new_value):
        self.abstraction_controller.predictor.change_hyperparameter(name, new_value)

    @Slot()
    def updater(self):
        candidates = self.abstraction_controller.get_sorted_pair_labels()
        process_model_string = f"abstractions_process_models/Abstraction{self.abstraction_controller.database.level_of_abstraction[self.abstraction_controller.database.currenttab]}.png"
        #print("Update new Candidates")
        self.updated.emit(candidates, len(
            candidates) - 1, process_model_string, self.abstraction_controller.database.level_of_abstraction[self.abstraction_controller.database.currenttab])

    @Slot(int)
    def addTab(self, tab):
        self.hyperparams.append(self.abstraction_controller.predictor.hyperparameters)
        self.abstraction_controller.newTab(tab)

    @Slot(int, int)
    def candidateSelected(self, candidate_index, tab):
        self.abstraction_controller.database.currenttab = tab
        print(f'tab: {tab}')
        print(f'User clicked on: {candidate_index}')
        self.abstraction_controller.set_pair_we_are_at(candidate_index)
        self.thread = QThread()

        self.worker = AbstractionWorker(self.abstraction_controller)
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run)

        self.worker.finished.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.thread.start()

        self.worker.finished.connect(

            lambda: self.updater()
        )

    @Slot(int)
    def recalculateCandidates(self, desired_abstraction_level):
        print("Recalculate Candidates")
        self.hyperparams[self.abstraction_controller.database.currenttab] = self.abstraction_controller.predictor.hyperparameters
        if (desired_abstraction_level != self.abstraction_controller.database.level_of_abstraction[self.abstraction_controller.database.currenttab]):
            self.abstraction_controller.database.set_level_of_abstraction(
                desired_abstraction_level)
            self.abstraction_controller.reset()
            print("ressetting")
        self.thread2 = QThread()

        self.worker2 = UpdateCandidatesWorker(self.abstraction_controller)
        self.worker2.moveToThread(self.thread2)
        self.thread2.started.connect(self.worker2.run)

        self.worker2.finished.connect(self.thread2.quit)
        self.worker2.finished.connect(self.worker2.deleteLater)
        self.thread2.finished.connect(self.thread2.deleteLater)
        self.thread2.start()

        self.worker2.finished.connect(

            lambda: self.updater()
        )

    def tabchanger(self):
        self.tabchanged.emit(
            self.abstraction_controller.database.level_of_abstraction[self.abstraction_controller.database.currenttab])

    @Slot(int)
    def changedtab(self, newtab):
        self.hyperparams[self.abstraction_controller.database.currenttab] = self.abstraction_controller.predictor.hyperparameters.copy()
        self.abstraction_controller.predictor.hyperparameters = self.hyperparams[newtab].copy()
        self.abstraction_controller.database.currenttab = newtab
        self.updater()
        self.tabchanger()
        self.get_metrics()
        print("Now on tab: ", newtab)
        print(self.hyperparams)

    @Slot(int)
    def deletetab(self, tab):
        print(tab)
        self.hyperparams.pop(tab)
        self.abstraction_controller.deletetab(tab)

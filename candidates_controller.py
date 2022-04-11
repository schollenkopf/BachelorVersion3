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

    tabchanged = Signal(int, float, float, float)

    @Slot(str, str, int, int, str, int, int, bool, int, int)
    def init_abstraction_controller(self, filename, time_string, number_columns, number_rows, separator, timestamp_column, number_chars_timestamp, inseconds, action_column, trace_column):
        self.abstraction_controller = AbstractionControl(filename, time_string, number_columns, number_rows, separator, timestamp_column, number_chars_timestamp, inseconds, action_column, trace_column)

    @Slot()
    def updater(self):
        candidates = self.abstraction_controller.get_sorted_pair_labels()
        process_model_string = f"abstractions_process_models/Abstraction{self.abstraction_controller.database.level_of_abstraction[self.abstraction_controller.database.currenttab]}.png"
        #print("Update new Candidates")
        self.updated.emit(candidates, len(
            candidates) - 1, process_model_string, self.abstraction_controller.database.level_of_abstraction[self.abstraction_controller.database.currenttab])

    @Slot(int, list)
    def addTab(self, tab, hyperparams):
        self.hyperparams.append(hyperparams)
        self.abstraction_controller.newTab(tab)

    @Slot(int, int, list)
    def candidateSelected(self, candidate_index, tab, hyperparameters):
        self.abstraction_controller.database.currenttab = tab
        print(f'tab: {tab}')
        print(f'User clicked on: {candidate_index}')
        self.abstraction_controller.set_pair_we_are_at(candidate_index)
        self.abstraction_controller.change_hyperparameters(hyperparameters)
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

    @Slot(int, list)
    def recalculateCandidates(self, desired_abstraction_level, hyperparameters):
        print("Recalculate Candidates")
        self.hyperparams[self.abstraction_controller.database.currenttab] = hyperparameters
        self.abstraction_controller.change_hyperparameters(hyperparameters)
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
        hypervalues = []
        for metric in self.hyperparams[self.abstraction_controller.database.currenttab]:
            for name in metric:
                hypervalues.append(metric[name])
        self.tabchanged.emit(
            self.abstraction_controller.database.level_of_abstraction[self.abstraction_controller.database.currenttab], hypervalues[0], hypervalues[1], hypervalues[2])

    @Slot(int, list)
    def changedtab(self, newtab, oldhyperparams):
        self.hyperparams[self.abstraction_controller.database.currenttab] = oldhyperparams
        self.abstraction_controller.database.currenttab = newtab
        self.updater()
        self.tabchanger()
        print("Now on tab: ", newtab)
        print(self.hyperparams)

    @Slot(int)
    def deletetab(self, tab):
        print(tab)
        self.hyperparams.pop(tab)
        self.abstraction_controller.deletetab(tab)

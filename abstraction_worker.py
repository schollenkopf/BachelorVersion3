from PySide6.QtCore import QObject, Signal, QThread

from thread_worker import ThreadWorker


class AbstractionWorker(ThreadWorker):

    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        QThread.currentThread().setObjectName("WORKER")
        self.abstraction_control.abstract()
        self.finished.emit()

class PatternAbstractionWorker(ThreadWorker):

    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        QThread.currentThread().setObjectName("WORKER")
        self.abstraction_control.pattern_abstract()
        self.finished.emit()



class DelRepEventTimeWorker(ThreadWorker):

    def __init__(self, abstraction_control, action_index, seconds):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control
        self.action_index = action_index
        self.seconds = seconds

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        QThread.currentThread().setObjectName("WORKER")
        self.abstraction_control.delete_repetitions_specific_event_time(self.action_index, self.seconds)
        print("I finished")
        self.finished.emit()

class DelRepEventWorker(ThreadWorker):

    def __init__(self, abstraction_control, action_index):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control
        self.action_index = action_index

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        QThread.currentThread().setObjectName("WORKER")
        self.abstraction_control.delete_repetitions_specific_event(self.action_index)
        self.finished.emit()

class DelAllRepWorker(ThreadWorker):

    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        QThread.currentThread().setObjectName("WORKER")
        self.abstraction_control.delete_all_repetitions()
        self.finished.emit()

class DelAllRepWorkerTime(ThreadWorker):

    def __init__(self, abstraction_control, seconds):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control
        self.seconds = seconds

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        QThread.currentThread().setObjectName("WORKER")
        self.abstraction_control.delete_all_repetitions_time(self.seconds)
        self.finished.emit()


class UpdateCandidatesWorker(ThreadWorker):
    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):

        QThread.currentThread().setObjectName("WORKER2")
        self.abstraction_control.get_new_prediction()

        self.finished.emit()

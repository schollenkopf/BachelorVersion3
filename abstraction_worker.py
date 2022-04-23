from PySide6.QtCore import QObject, Signal, QThread


class AbstractionWorker(QObject):

    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        QThread.currentThread().setObjectName("WORKER")
        self.abstraction_control.abstract()
        self.finished.emit()

class PatternAbstractionWorker(QObject):

    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        QThread.currentThread().setObjectName("WORKER")
        self.abstraction_control.pattern_abstract()
        self.finished.emit()



class DelRepEventTimeWorker(QObject):

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

class DelRepEventWorker(QObject):

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

class DelAllRepWorker(QObject):

    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        QThread.currentThread().setObjectName("WORKER")
        self.abstraction_control.delete_all_repetitions()
        self.finished.emit()

class DelAllRepWorkerTime(QObject):

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


class UpdateCandidatesWorker(QObject):
    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):

        QThread.currentThread().setObjectName("WORKER2")
        self.abstraction_control.get_new_prediction()

        self.finished.emit()

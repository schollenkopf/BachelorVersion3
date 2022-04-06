from PySide6.QtCore import QObject, Signal, QThread


class AbstractionWorker(QObject):

    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        QThread.currentThread().setObjectName("WORKER")
        print("MERGE THREAD app:", QThread.currentThread())
        self.abstraction_control.abstract()
        print("5", QThread.currentThread().objectName())
        self.finished.emit()
        print("6", QThread.currentThread().objectName())

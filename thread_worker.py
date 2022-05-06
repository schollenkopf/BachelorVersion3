from PySide6.QtCore import QObject, Signal

class ThreadWorker(QObject):

    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control

    finished = Signal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        pass
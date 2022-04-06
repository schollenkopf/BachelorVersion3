
from PyQt6.QtCore import QObject, pyqtSignal, pyqtSlot
from PyQt6.QtCore import QObject, QThread, pyqtSignal
from abstraction_worker import AbstractionWorker

class YesNoButtons(QObject):

    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control
        self.thread = None
        self.worker = None

    updated = pyqtSignal(str, arguments=['updater'])

    def updater(self, nextmerge):
        self.updated.emit(nextmerge)

    @pyqtSlot()
    def yes(self):
        self.updater("Loading ... ")
        self.thread = QThread()
        self.worker = AbstractionWorker(self.abstraction_control)
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run)
        self.worker.finished.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.thread.start()
        self.thread.finished.connect(
            lambda: self.updater(self.abstraction_control.get_message())
        )

    @pyqtSlot()
    def no(self):
        self.abstraction_control.no()
        self.updater(self.abstraction_control.get_message())


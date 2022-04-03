
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtCore import QObject, pyqtSignal, pyqtSlot
from PyQt6.QtCore import QObject, QThread, pyqtSignal

from abstraction_control import AbstractionControl


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
        self.worker = Worker(self.abstraction_control)
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


class Worker(QObject):

    def __init__(self, abstraction_control):
        QObject.__init__(self)
        self.abstraction_control = abstraction_control

    finished = pyqtSignal()
    # progress = pyqtSignal(int) We could implement

    def run(self):
        self.abstraction_control.yes()
        self.finished.emit()


class Window(QQmlApplicationEngine):
    def __init__(self, app, parent=None):
        super().__init__(parent)
        self.clicksCount = 0
        self.app = app
        self.abstraction_control = AbstractionControl()
        self.yes_no_button = YesNoButtons(self.abstraction_control)
        self.setupUi()

    def setupUi(self):
        self.load('./UI/main.qml')
        self.quit.connect(self.app.quit)
        self.rootObjects()[0].setProperty('yes_no_button', self.yes_no_button)
        self.yes_no_button.updater(self.abstraction_control.get_message())

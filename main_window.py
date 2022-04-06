
from PyQt6.QtQml import QQmlApplicationEngine
from abstraction_control import AbstractionControl
from candidates_controller import CandidateController
from yes_no_button import YesNoButtons

from candidate_list_model import CandidateListModel


class Window(QQmlApplicationEngine):
    def __init__(self, app, parent=None):
        super().__init__(parent)
        self.clicksCount = 0
        self.app = app
        self.abstraction_control = AbstractionControl()
        self.yes_no_button = YesNoButtons(self.abstraction_control)
        self.candidate_controller = CandidateController(self.abstraction_control)
        self.setupUi()
        

    def setupUi(self):
        self.load('main.qml')
        self.quit.connect(self.app.quit)
        self.rootContext().setContextProperty('yes_no_button', self.yes_no_button)
        self.rootContext().setContextProperty('candidate_controller', self.candidate_controller)
        """
        self.rootObjects()[0].setProperty('yes_no_button', self.yes_no_button)
        self.rootObjects()[0].setProperty('candidate_controller', self.candidate_controller)"""
        self.yes_no_button.updater(self.abstraction_control.get_message())
        
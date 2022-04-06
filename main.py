"""
from main_window import *

from PyQt6.QtGui import QGuiApplication

import sys
from candidate_list_model import CandidateListModel

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    win = Window(app)
    sys.exit(app.exec())"""


import sys
from pathlib import Path

from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from candidate_list_model import CandidateListModel
from candidates_controller import CandidateController
from abstraction_control import AbstractionControl

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    qml_file = Path(__file__).parent / "main.qml"

    abstraction_control = AbstractionControl()
    candidate_list_model = CandidateListModel()
    candidate_controller = CandidateController(abstraction_control)

    context = engine.rootContext()
    context.setContextProperty('candidate_list_model', candidate_list_model)
    context.setContextProperty('candidate_controller', candidate_controller)

    engine.load(QUrl.fromLocalFile(qml_file))

    candidate_controller.updater()

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
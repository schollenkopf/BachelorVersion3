import sys
from pathlib import Path

from PySide6.QtCore import QUrl, QThread
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from display_datalog import DataFrameModel

from id_generator import IdGenerator
from candidate_list_model import CandidateListModel
from candidates_controller import CandidateController
from abstraction_control import AbstractionControl

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    qml_file = Path(__file__).parent / "main.qml"

    filename = "Data.csv"
    time_string = "%Y-%m-%dT%H:%M:%S.%f" 
    number_columns = 6
    number_rows = 8114
    separator = ";"
    timestamp_column = 3
    number_chars_timestamp = 26
    inseconds = False
    action_column = 5
    trace_column = 0

    abstraction_control = AbstractionControl(filename, time_string, number_columns, number_rows, separator, timestamp_column, number_chars_timestamp, inseconds, action_column, trace_column)
    candidate_list_model = CandidateListModel()
    candidate_controller = CandidateController(abstraction_control)
    display_datalog = DataFrameModel(filename, separator, number_columns, number_rows)
    context = engine.rootContext()
    context.setContextProperty('candidate_list_model', candidate_list_model)
    context.setContextProperty('candidate_controller', candidate_controller)
    context.setContextProperty('candidate_controller', candidate_controller)
    context.setContextProperty('table_model', display_datalog)

    engine.load(QUrl.fromLocalFile(qml_file))
    QThread.currentThread().setObjectName("MAIN")
    candidate_controller.updater()

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())

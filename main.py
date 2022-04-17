import sys
from pathlib import Path


from PySide6.QtCore import QUrl, QThread
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, QQmlComponent, qmlRegisterType
from display_datalog import DataFrameModel
from candidate_list_model import CandidateListModel
from candidates_controller import CandidateController
from point_manager import PointManager


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    qml_file = Path(__file__).parent / "main.qml"

    candidate_list_model = CandidateListModel()
    candidate_controller = CandidateController()
    display_datalog = DataFrameModel()
    point_manager = PointManager(candidate_controller)

    context = engine.rootContext()

    context.setContextProperty('manager', point_manager)
    context.setContextProperty('candidate_list_model', candidate_list_model)
    context.setContextProperty('candidate_controller', candidate_controller)
    context.setContextProperty('table_model', display_datalog)

    engine.load(QUrl.fromLocalFile(qml_file))

    QThread.currentThread().setObjectName("MAIN")

    # point_manager.draw_x()

    if not engine.rootObjects():

        sys.exit(-1)
    sys.exit(app.exec())

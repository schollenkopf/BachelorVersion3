import sys
from pathlib import Path


from PySide6.QtCore import QUrl, QThread
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, QQmlComponent, qmlRegisterType
from cluster_list_model import ClusterListModel
from display_datalog import DataFrameModel
from candidate_list_model import CandidateListModel
from candidates_controller import ThreadController
from point_manager import PointManager

from metrics_list_model import MetricsListModel
from actions_list_model import ActionListModel

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    qml_file = Path(__file__).parent / "main.qml"

    actions_list_model = ActionListModel()
    candidate_list_model = CandidateListModel()
    metrics_list_model = MetricsListModel()
    candidate_controller = ThreadController()
    cluster_list_model = ClusterListModel()
    display_datalog = DataFrameModel()
    point_manager = PointManager(candidate_controller)

    context = engine.rootContext()

    context.setContextProperty('manager', point_manager)
    context.setContextProperty('candidate_list_model', candidate_list_model)
    context.setContextProperty('metrics_list_model', metrics_list_model)
    context.setContextProperty('candidate_controller', candidate_controller)
    context.setContextProperty('table_model', display_datalog)
    context.setContextProperty('actions_list_model', actions_list_model)
    context.setContextProperty('cluster_list_model', cluster_list_model)

    engine.load(QUrl.fromLocalFile(qml_file))   
    QThread.currentThread().setObjectName("MAIN")

    # point_manager.draw_x()

    if not engine.rootObjects():

        sys.exit(-1)
    sys.exit(app.exec())

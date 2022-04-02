
from main_window import *

from PyQt6.QtGui import QGuiApplication

import sys

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    win = Window(app)
    sys.exit(app.exec())

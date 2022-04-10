
from PySide6.QtCore import Slot, QObject, QThread, Signal


class IdGenerator(QObject):

    @Slot(str, str)
    def generate_id(id, tab):
        return id + tab

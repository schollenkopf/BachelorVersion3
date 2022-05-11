from PySide6.QtCore import (QAbstractListModel, QModelIndex, Qt, Slot)
"""
from PySide6.QtQml import QmlElement

QML_IMPORT_NAME = "CandidateListModel"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement"""


class CandidateListModel(QAbstractListModel):

    MetricsRole = Qt.UserRole + 1

    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.db = []

    def roleNames(self):
        default = super().roleNames()
        default[CandidateListModel.MetricsRole] = b"metricsrole"
        return default

    @Slot(result=int)
    def rowCount(self, parent=QModelIndex()):
        return len(self.db)

    @Slot(int)
    def print_clicked(self, index):
        print(self.db[index]["text"])

    def data(self, index, role):
        if not self.db:
            ret = None
        elif not index.isValid():
            ret = None
        elif role == Qt.DisplayRole:
            ret = self.db[index.row()]["text"]
        elif role == CandidateListModel.MetricsRole:
            ret = self.db[index.row()]["metrics"]
        else:
            ret = None
        return ret
    """
    def setData(self, index, value, role):
        if not index.isValid():
            return False
        if role == Qt.EditRole:
            self.db[index.row()]["text"] = value
        return True"""

    @Slot(int, int, list, result=bool)
    def insertRows(self, row: int, count, new_candidates, index=QModelIndex()):
        # Insert n rows (n = 1 + count)  at row

        self.beginInsertRows(QModelIndex(), row, row + count)

        # start database work
        for i, (e1, e2, metrics) in enumerate(new_candidates):  # at least one row
            self.db.insert(
                row + i, {"text": e1 + "-" + e2, "metrics": metrics}
            )
        # end database work
        self.endInsertRows()
        return True

    @Slot(int, int, result=bool)
    def removeRows(self, row: int, count, index=QModelIndex()):
        self.beginRemoveRows(QModelIndex(), row, count)
        self.db = self.db[:row] + self.db[row + count + 1:]
        self.endRemoveRows()
        return True

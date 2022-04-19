from PySide6.QtCore import (QAbstractListModel, QModelIndex, Qt, Slot)
"""
from PySide6.QtQml import QmlElement

QML_IMPORT_NAME = "CandidateListModel"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement"""
class ClusterListModel(QAbstractListModel):

    ColorRole = Qt.UserRole + 11
    #SizeRole = Qt.UserRole + 12

    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.db = []

    def roleNames(self):
        default = super().roleNames()
        default[ClusterListModel.ColorRole] = b"colorrole"
        return default

    @Slot(result=int)
    def rowCount(self, parent=QModelIndex()):
        return len(self.db)

    def data(self, index, role):
        if not self.db:
            ret = None
        elif not index.isValid():
            ret = None
        elif role ==  Qt.DisplayRole:
            ret = self.db[index.row()]["text"]
        elif role == ClusterListModel.ColorRole:
            ret = self.db[index.row()]["color"]
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
    def insertRows(self, row: int, count, clusters, index=QModelIndex()):
        #Insert n rows (n = 1 + count)  at row

        self.beginInsertRows(QModelIndex(), row, row + count)

        # start database work
        for i, (name,color) in enumerate(clusters):  # at least one row
            self.db.insert(
                row + i, {"text": name, "color": color}
            )
        # end database work
        self.endInsertRows()
        return True

    @Slot(int, int, result=bool)
    def removeRows(self, row: int, count, index=QModelIndex()):
         self.beginRemoveRows(QModelIndex(), row, count)
         self.db = self.db[:row] + self.db[row + count + 1 :]
         self.endRemoveRows()
         return True





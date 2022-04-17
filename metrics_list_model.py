from PySide6.QtCore import (QAbstractListModel, QModelIndex, Qt, Slot)

class MetricsListModel(QAbstractListModel):

    MetricsRole = Qt.UserRole + 1

    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.db = []

    def roleNames(self):
        default = super().roleNames()
        default[MetricsListModel.MetricsRole] = b"valuemetric"
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
            ret = self.db[index.row()]["name"]
        elif role == MetricsListModel.MetricsRole:
            ret = self.db[index.row()]["valuemetric"]
        else:
            ret = None
        return ret

    @Slot(int, int, list, result=bool)
    def insertRows(self, row: int, count, metrics, index=QModelIndex()):
        #Insert n rows (n = 1 + count)  at row

        self.beginInsertRows(QModelIndex(), row, row + count)

        # start database work
        for i, (name, value) in enumerate(metrics):  # at least one row
            self.db.insert(
                row + i, {"name": name, "valuemetric": round(value, 2)}
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


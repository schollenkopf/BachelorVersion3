from PySide6.QtCore import Slot, QAbstractTableModel, Qt, Property, QModelIndex
import pandas as pd

class DataFrameModel(QAbstractTableModel):
    DtypeRole = Qt.UserRole + 1000
    ValueRole = Qt.UserRole + 1001

    def __init__(self, parent=None):
        super(DataFrameModel, self).__init__(parent)
        self.n_cols = []
        self.rows = 0
        self._dataframe = None

    @Slot(int, int)
    def first_setUp(self, number_columns, number_rows):
        self.beginResetModel()
        self.n_cols = [*range(number_columns)]
        self.rows = number_rows
        self._dataframe = pd.read_csv(f"tab0/abstractions/Abstraction0.csv", sep=",", usecols=self.n_cols, nrows=self.rows)
        self.endResetModel()

    @Slot(int, int)
    def setDataFrame(self, tab_index, slider_value):
        self.beginResetModel()
        self._dataframe = pd.read_csv(f"tab{tab_index}/abstractions/Abstraction{slider_value}.csv", sep=",", usecols=self.n_cols, nrows=self.rows)
        self.endResetModel()

    def dataFrame(self):
        return self._dataframe

    dataFrame = Property(pd.DataFrame, fget=dataFrame, fset=setDataFrame)

    @Slot(int, Qt.Orientation, result=str)
    def headerData(self, section: int, orientation: Qt.Orientation, role: int = Qt.DisplayRole):
        if role == Qt.DisplayRole:
            if orientation == Qt.Horizontal:
                return self._dataframe.columns[section]
            else:
                return str(self._dataframe.index[section])
        return ""

    def rowCount(self, parent=QModelIndex()):
        if parent.isValid():
            return 0
        return len(self._dataframe.index)

    def columnCount(self, parent=QModelIndex()):
        if parent.isValid():
            return 0
        return self._dataframe.columns.size

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid() or not (0 <= index.row() < self.rowCount() \
            and 0 <= index.column() < self.columnCount()):
            return None
        row = self._dataframe.index[index.row()]
        col = self._dataframe.columns[index.column()]
        dt = self._dataframe[col].dtype

        val = self._dataframe.iloc[row][col]
        if role == Qt.DisplayRole:
            return str(val)
        elif role == DataFrameModel.ValueRole:
            return val
        if role == DataFrameModel.DtypeRole:
            return dt
        return None

    def roleNames(self):
        roles = {
            Qt.DisplayRole: b'display',
            DataFrameModel.DtypeRole: b'dtype',
            DataFrameModel.ValueRole: b'value'
        }
        return roles
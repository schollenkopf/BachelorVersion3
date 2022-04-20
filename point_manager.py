import os
import random
import sys
from pathlib import Path
from turtle import update
import numpy as np
import matplotlib

from PySide6.QtCore import Property, QUrl, QObject, Qt, Slot, Signal
from PySide6.QtGui import QColor, QGuiApplication, QStandardItem, QStandardItemModel
from PySide6.QtQuick import QQuickView

XPosRole = Qt.UserRole
YPosRole = Qt.UserRole + 1
IdRole = Qt.UserRole + 2


class PointManager(QObject):
    def __init__(self, candidate_controller, parent=None):
        super().__init__(parent)
        self.candidate_controller = candidate_controller
        self._model = QStandardItemModel()
        self._model.setItemRoleNames(
            {Qt.DisplayRole: b"display", XPosRole: b"xpos", YPosRole: b"ypos", IdRole: b"point_id"})
        self.color_column_nr = None
        self.cluster_column_nr = None
        self.colors = list(matplotlib.colors.cnames.values())
        self.current_color = 0
        self.color_dict = {}

    init = Signal(list)
    pointsselected = Signal(int, int, int, int)
    update_clusters = Signal(list,int)

    @Property(QObject, constant=True)
    def model(self):
        return self._model

    def add_point(self, color, xpos, ypos, id):
        item = QStandardItem(color)
        item.setData(xpos, XPosRole)
        item.setData(ypos, YPosRole)
        item.setData(id, IdRole)
        
        self._model.appendRow(item)

    

    def filter_data_by_trace(self, trace):
        rawdata = self.data
        array_of_rows = np.array([], dtype=np.int32)
        for row, event in enumerate(rawdata.values):
            if event[self.candidate_controller.abstraction_controller.trace_column] == trace:
                array_of_rows = np.append(array_of_rows, row)
        return array_of_rows

    @Slot()
    def initialise_data(self):
        self.data = self.candidate_controller.abstraction_controller.preSetUp()
        self.original_timestamp_column = self.data.iloc[:,self.candidate_controller.abstraction_controller.timestamp_column].copy().values
        print(self.original_timestamp_column)

        for trace in list(self.data[self.data.columns[self.candidate_controller.abstraction_controller.trace_column]].unique()):
            is_first = True
            first_time = 0

            for n in self.filter_data_by_trace(trace):
                if is_first:
                    first_time = self.data.iloc[n,
                                                self.candidate_controller.abstraction_controller.timestamp_column]
                    
                    is_first = False
                
                before = self.data.iloc[n,
                                        self.candidate_controller.abstraction_controller.timestamp_column]
                self.data.iat[n, self.candidate_controller.abstraction_controller.timestamp_column] = before - first_time
               
        print(self.data.head())
        print(self.data.tail())

        len = self.data.shape[0]
        self.color_column_nr = self.data.shape[1]
        self.cluster_column_nr = self.data.shape[1] + 1
        color_column = ["blue"]*len
        cluster_column = ["no_cluster"]*len
        self.data = self.data.assign(
            color=color_column, cluster=cluster_column)
        self.init.emit(list(self.data.columns))
        self.update_cluster_list()

    @Slot(str, bool, str, bool, int, int, int, int, int)
    def draw_scatter(self, x_column, number_x, y_column, number_y, width, height,margin_right,margin_bottom,margin_left):

        
        #width = width - margin_right - margin_left
        #height = height - margin_bottom
        
        self._model.clear()

        x_column_nr = self.data.columns.get_loc(x_column)
        y_column_nr = self.data.columns.get_loc(y_column)

        min_x = self.data[x_column].min()
        max_x = self.data[x_column].max()
        min_y = self.data[y_column].min()
        max_y = self.data[y_column].max()

        

        if not number_y:
            items_y = self.data[y_column].unique()

        if not number_x:
            items_x = self.data[x_column].unique()
        # if not x_discrete and not y_discrete:
        for n, event in enumerate(self.data.values):

            if number_x:
                x_cord = (event[x_column_nr]-min_x)*(width/(max_x-min_x))
            if number_y:
                y_cord = height-(event[y_column_nr] -
                                 min_y) * (height/(max_y-min_y))
            if not number_x:
                x_cord = (np.where(items_x == event[x_column_nr])[
                          0][0])*(width/len(items_x))
            if not number_y:
                y_cord = height - \
                    (np.where(items_y == event[y_column_nr])[
                     0][0])*(height/len(items_y))

            color = event[self.color_column_nr]

            if event[self.cluster_column_nr] == "current_selection":
                color = "black"

            self.add_point(color, round(x_cord), round(y_cord), n)

    @Slot(int, int, int, int, int)
    def color_points(self, height, width, rotation, x, y):
        if (rotation == 0):
            self.pointsselected.emit(x, y, x + width, y + height)

        elif (rotation == -90):
            self.pointsselected.emit(x, y - width, x + height, y)

        elif (rotation == 90):

            self.pointsselected.emit(x - height, y, x, y + width)

        elif (rotation == -180):

            self.pointsselected.emit(x - width, y - height, x, y)
    
    @Slot(str)
    def color_by_column(self,column):
        items = self.data[column].unique()
        self.color_dict = {}
        column_nr = self.data.columns.get_loc(column)
        print(items)
        if len(items) < 140:
            for i in range (len(items)):
                self.color_dict[items[i]] = self.colors[self.current_color]
                self.current_color += 1
            print(self.color_dict)
            for n,event in enumerate (self.data.values):
                self.data.iat[n,self.color_column_nr] = self.color_dict[event[column_nr]]
                self.data.iat[n,self.cluster_column_nr] = event[column_nr]
            print(self.data.head())
        self.update_cluster_list()
    
    @Slot(int)
    def add_to_current_selection(self,id_point):
        
        
        self.data.iat[id_point,self.cluster_column_nr] = "current_selection"
    
    @Slot(str)
    def create_cluster(self,name):
        
        cluster_already_exits = False
        if name in self.color_dict:
            cluster_already_exits = True
        else:    
            self.current_color += 1
        for n,event in enumerate (self.data.values):
            if event[self.cluster_column_nr] == "current_selection":
                if (cluster_already_exits):
                    self.data.iat[n,self.color_column_nr] = self.color_dict[name]
                else:
                    self.data.iat[n,self.color_column_nr] = self.colors[self.current_color]
                    self.color_dict[name] = self.colors[self.current_color]
                self.data.iat[n,self.cluster_column_nr] = name
        self.update_cluster_list()
                

    @Slot()
    def forget_selection(self):
        for n,event in enumerate (self.data.values):
            if event[self.cluster_column_nr] == "current_selection":
                cluster = "no_cluster"
                if self.color_dict:
                    keys = [k for k, v in self.color_dict.items() if v == event[self.color_column_nr]]
                    if keys:
                        cluster = keys[0]
                
                    
                self.data.iat[n,self.cluster_column_nr] = cluster
    
    def update_cluster_list(self):
        clusters = set()
        for event in (self.data.values):
            clusters.add((event[self.cluster_column_nr],event[self.color_column_nr]))
        self.update_clusters.emit(list(clusters),len(list(clusters))-1)
    
    @Slot()
    def init_abstraction_page(self):
        data = self.data.drop(labels = "color", axis=1)
        data[self.data.columns[self.candidate_controller.abstraction_controller.timestamp_column]] = self.original_timestamp_column
        self.candidate_controller.abstraction_controller.setUp(data)

    



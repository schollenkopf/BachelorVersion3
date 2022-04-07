
import pandas as pd
from neo4j import GraphDatabase
from pathlib import Path
from PySide6.QtCore import QThread
import graphviz


class Database:

    def __init__(self, action_column, trace_column, timestamp_column, uri, user, password):
        self.latest_log = None
        self.level_of_abstraction = -1
        self.action_column = action_column
        self.trace_column = trace_column
        self.timestamp_column = timestamp_column
        self.events_deleted_last_abstraction = 0
        self.driver = GraphDatabase.driver(uri, auth=(user, password))
        self.abstraction_tree_string = ""
        with self.driver.session() as session:
            session.run("Match (n) Detach Delete (n)")

    def init_abstraction_tree_string(self):
        initial_string = ""
        for action in self.get_actions():
            initial_string = initial_string + action + ";"
        self.abstraction_tree_string = initial_string

    def update_latest_log(self, data):
        if self.level_of_abstraction >= 0:
            path_file = Path(
                __file__).parent / f"abstractions/Abstraction{self.level_of_abstraction}.csv"
            data.to_csv(path_file, index=False)
        self.latest_log = data
        self.latest_log = self.latest_log.reset_index(drop=True)

    def get_latest_log(self):
        return self.latest_log

    def get_actions(self):
        return list(self.latest_log[self.latest_log.columns[self.action_column]].unique())

    def get_action_column(self):
        return self.action_column

    def get_timestamp_column(self):
        return self.timestamp_column

    def get_trace_column(self):
        return self.trace_column

    def get_number_of_traces(self):
        return len(list(self.latest_log[self.latest_log.columns[self.trace_column]].unique()))

    def get_traces(self):
        return list(self.latest_log[self.latest_log.columns[self.trace_column]].unique())

    def change_event(self, row_number, column_number, new_value):
        self.latest_log.at[row_number,
                           self.latest_log.columns[column_number]] = new_value

    def delete_events(self, ids_to_delete):
        self.latest_log = self.latest_log.drop(labels=ids_to_delete, axis=0)
        self.latest_log = self.latest_log.reset_index(drop=True)
        self.events_deleted_last_abstraction = len(ids_to_delete)

    def initiate_tree(self):
        with self.driver.session() as session:
            for action in self.get_actions():
                session.run("Create (e:Action{name: \""+action+"\"})")
        self.driver.close()

    def update_tree(self, e1, e2, enew):
        self.build_abstraction_tree(e1, e2, self.level_of_abstraction)
        print(self.abstraction_tree_string)
        self.generate_tree()
        with self.driver.session() as session:
            session.run("Create (e:Action{name: \""+enew+"\"})")
            session.run("MATCH(a:Action),(b:Action),(c:Action) WHERE a.name = \""+e1+"\" AND b.name = \"" +
                        e2+"\" AND c.name = \""+enew+"\" CREATE (c)-[r:ABSTRACTS]->(a) CREATE (c)-[r2:ABSTRACTS]->(b) ")
        self.driver.close()

    def build_abstraction_tree(self, e1, e2, level_of_abstraction):
        self.abstraction_tree_string = self.abstraction_tree_string + e1 + "->" + e1 + e2 + \
            "[label = " + str(level_of_abstraction) + "]" + ";"
        self.abstraction_tree_string = self.abstraction_tree_string + e2 + "->" + e1 + e2 + \
            "[label = " + str(level_of_abstraction) + "]" + ";"

    def generate_tree(self):
        name = f"abstraction_tree{self.level_of_abstraction}"

        dot = graphviz.Source(
            'digraph "tree" { ' + self.abstraction_tree_string + '}', name)
        dot.format = 'png'
        dot.render(directory='abstraction_tree/')

    def increase_level_of_abstraction(self):
        print("increasing")
        self.level_of_abstraction += 1

    def set_level_of_abstraction(self, desired):
        self.level_of_abstraction = desired
        print(self.level_of_abstraction)

    def reset(self, data):
        self.latest_log = data
        abstraction_tree_file_name = "abstraction_tree/abstraction_tree" + \
            str(self.level_of_abstraction)
        text_file = open(abstraction_tree_file_name, "r")

        cut_file = text_file.read()
        cut_file = cut_file[16:]
        self.abstraction_tree_string = cut_file[:-2]
        print(self.abstraction_tree_string)
        text_file.close()

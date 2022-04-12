

#from neo4j import GraphDatabase
from operator import truediv
from pathlib import Path
import graphviz
import shutil
import os


class Database:

    # , uri, user, password):
    def __init__(self, action_column, trace_column, timestamp_column):
        self.latest_log = [None]
        self.level_of_abstraction = [-1]
        self.action_column = action_column
        self.trace_column = trace_column
        self.timestamp_column = timestamp_column
        self.events_deleted_last_abstraction = 0
        self.abstraction_tree_string = [""]
        self.currenttab = 0
        """
        self.driver = GraphDatabase.driver(uri, auth=(user, password))
        with self.driver.session() as session:
            session.run("Match (n) Detach Delete (n)")
        """

    def init_abstraction_tree_string(self):
        initial_string = ""
        for action in self.get_actions():
            initial_string = initial_string + action + \
                "[color = white; fontcolor = white];"
        self.abstraction_tree_string[self.currenttab] = initial_string

    def update_latest_log(self, data):
        if self.level_of_abstraction[self.currenttab] >= 0:
            path_file = Path(
                __file__).parent / f"tab{self.currenttab}/abstractions/Abstraction{self.level_of_abstraction[self.currenttab]}.csv"
            data.to_csv(path_file, index=False)
        self.latest_log[self.currenttab] = data
        self.latest_log[self.currenttab] = self.latest_log[self.currenttab].reset_index(
            drop=True)

    def get_latest_log(self):
        return self.latest_log[self.currenttab]

    def get_actions(self):
        return list(self.latest_log[self.currenttab][self.latest_log[self.currenttab].columns[self.action_column]].unique())

    def get_action_column(self):
        return self.action_column

    def get_timestamp_column(self):
        return self.timestamp_column

    def get_trace_column(self):
        return self.trace_column

    def get_number_of_traces(self):
        return len(list(self.latest_log[self.currenttab][self.latest_log[self.currenttab].columns[self.trace_column]].unique()))

    def get_traces(self):
        return list(self.latest_log[self.currenttab][self.latest_log[self.currenttab].columns[self.trace_column]].unique())

    def change_event(self, row_number, column_number, new_value):
        self.latest_log[self.currenttab].at[row_number,
                                            self.latest_log[self.currenttab].columns[column_number]] = new_value

    def delete_events(self, ids_to_delete):
        self.latest_log[self.currenttab] = self.latest_log[self.currenttab].drop(
            labels=ids_to_delete, axis=0)
        self.latest_log[self.currenttab] = self.latest_log[self.currenttab].reset_index(
            drop=True)
        self.events_deleted_last_abstraction = len(ids_to_delete)

    """
    def initiate_tree(self):
        with self.driver.session() as session:
            for action in self.get_actions():
                session.run("Create (e:Action{name: \""+action+"\"})")
        self.driver.close()
    """

    def update_tree(self, e1, e2, enew):
        print("one")
        self.build_abstraction_tree(
            e1, e2, self.level_of_abstraction[self.currenttab])
        # print(self.abstraction_tree_string[self.currenttab])
        self.generate_tree()
        """
        with self.driver.session() as session:
            session.run("Create (e:Action{name: \""+enew+"\"})")
            session.run("MATCH(a:Action),(b:Action),(c:Action) WHERE a.name = \""+e1+"\" AND b.name = \"" +
                        e2+"\" AND c.name = \""+enew+"\" CREATE (c)-[r:ABSTRACTS]->(a) CREATE (c)-[r2:ABSTRACTS]->(b) ")
        self.driver.close()
        """

    def build_abstraction_tree(self, e1, e2, level_of_abstraction):
        self.abstraction_tree_string[self.currenttab] = self.abstraction_tree_string[self.currenttab] + \
            e1 + e2 + "[color = white; fontcolor = white];"
        self.abstraction_tree_string[self.currenttab] = self.abstraction_tree_string[self.currenttab] + e1 + "->" + e1 + e2 + \
            "[label = " + str(level_of_abstraction) + ";color = white;fontcolor = white]" + ";"
        self.abstraction_tree_string[self.currenttab] = self.abstraction_tree_string[self.currenttab] + e2 + "->" + e1 + e2 + \
            "[label = " + str(level_of_abstraction) + ";color = white;fontcolor = white]" + ";"

    def generate_tree(self):
        name = f"abstraction_tree{self.level_of_abstraction[self.currenttab]}"

        dot = graphviz.Source(
            'digraph "tree" { bgcolor="transparent"' + self.abstraction_tree_string[self.currenttab] + '}', name)
        dot.format = 'png'
        dir = f"tab{self.currenttab}/abstraction_tree/"
        dot.render(directory=dir)

    def increase_level_of_abstraction(self):
        print("increasing")
        self.level_of_abstraction[self.currenttab] += 1

    def set_level_of_abstraction(self, desired):
        self.level_of_abstraction[self.currenttab] = desired
        print(self.level_of_abstraction[self.currenttab])

    def reset(self, data):
        self.latest_log[self.currenttab] = data
        abstraction_tree_file_name = f"tab{self.currenttab}/abstraction_tree/abstraction_tree" + \
            str(self.level_of_abstraction[self.currenttab])
        text_file = open(abstraction_tree_file_name, "r")
# 16 + 21
        cut_file = text_file.read()
        cut_file = cut_file[38:]
        self.abstraction_tree_string[self.currenttab] = cut_file[:-2]
        # print(self.abstraction_tree_string)
        text_file.close()

    def newTab(self, tabid):
        self.level_of_abstraction.append(self.level_of_abstraction[0])
        self.latest_log.append(self.latest_log[0].copy())
        self.abstraction_tree_string.append(self.abstraction_tree_string[0])
        tree_src = "tab0"
        tree_dst = "tab" + str(tabid)
        if (os.path.isdir(tree_dst)):
            shutil.rmtree(tree_dst)
        shutil.copytree(tree_src, tree_dst)

    def deletetab(self, tab):
        self.level_of_abstraction.pop(tab)
        self.latest_log.pop(tab)
        self.abstraction_tree_string.pop(tab)
        folder = "tab0"

        num = 0
        found_folder = False
        while (os.path.isdir(folder)):
            print(folder)
            if num == tab:
                shutil.rmtree(folder)
                found_folder = True
            elif found_folder:
                new_name = "tab" + str(num-1)
                os.rename(folder, new_name)
            num = num + 1
            folder = "tab" + str(num)

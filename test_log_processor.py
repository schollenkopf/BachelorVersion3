from asyncio.windows_events import NULL
import unittest
from csv_reader import CSVReader
from log_processor import LogProcessor
from database import Database

class TestLogProcessor(unittest.TestCase):

    def setUp(self):
        self.csv_reader = CSVReader()
        self.database = Database(2, 0, 1)
        data = self.csv_reader.read_data("Test.csv", "%H:%M:%S", 3, 18, ",", 1, 8, False)
        self.database.update_latest_log(data)
        self.log_processor = LogProcessor(database=self.database)
        #print(self.database.latest_log[0].head())

    def test_abstract_log(self):
        new_action_name = "NewAction"
        actions = self.database.get_actions()
        for action1 in actions:
            for action2 in actions:
                if action1 != action2:
                    self.setUp()
                    lenght_before = len(self.database.get_latest_log())
                    indx_action1 = []
                    indx_action2 = []
                    for i, event in enumerate(self.database.get_latest_log().values):
                        if event[self.database.get_action_column()] == action1:
                            indx_action1.append(i)
                        if event[self.database.get_action_column()] == action2:
                            indx_action2.append(i)

                    self.log_processor.abstract_log(action1, action2, new_action_name)

                    for i, event in enumerate(self.database.get_latest_log().values):
                        self.assertNotEqual(event[self.database.get_action_column()], action1)
                        self.assertNotEqual(event[self.database.get_action_column()], action2)

                        if i in indx_action1 or i in indx_action2:
                            self.assertEqual(event[self.database.get_action_column()], new_action_name)

                    lenght_after = len(self.database.get_latest_log())
                    self.assertEqual(lenght_before, lenght_after)
    
    def test_filter_data_by_trace(self):
        rawdata = self.database.get_latest_log().values
        for trace in self.database.get_traces():
            indx = self.log_processor.filter_data_by_trace(trace)
            for i in indx:
                self.assertEqual(rawdata[i][self.database.get_trace_column()], trace)

    def test_abstract_log_pattern(self):
        actions = self.database.get_actions()
        for action1 in actions:
            for action2 in actions:
                if action1 != action2:
                    new_action_name = action1 + action2
                    self.setUp()
                    lenght_before = len(self.database.get_latest_log())
                    n_patterns = 0
                    rawdata = self.database.get_latest_log()
                    rawdata_values = rawdata.values
                    for trace in self.database.get_traces():

                        previous_event = []
                        
                        for i in self.log_processor.filter_data_by_trace(trace):
                            event = rawdata_values[i, :]
                            if len(previous_event) > 0 and event[self.database.get_action_column()] == action2 and previous_event[self.database.get_action_column()] == action1:
                                n_patterns += 1
                            previous_event = event

                    self.log_processor.abstract_log_pattern(action1, action2, new_action_name)

                    index_check = 0

                    for i, event in enumerate(self.database.get_latest_log().values):

                        if event[self.database.get_action_column()] == new_action_name:
                            index_check += 1

                    lenght_after = len(self.database.get_latest_log())
                    self.assertEqual(n_patterns, index_check)
                    self.assertEqual(lenght_before, lenght_after + n_patterns)

    def test_delete_repetitions(self):
        lenght_before = len(self.database.get_latest_log())
        n_delted_repetitions = 0
        rawdata = self.database.get_latest_log()
        rawdata_values = rawdata.values
        for trace in self.database.get_traces():

            previous_event = []
            
            for i in self.log_processor.filter_data_by_trace(trace):
                event = rawdata_values[i, :]
                if len(previous_event) > 0 and event[self.database.get_action_column()] ==  previous_event[self.database.get_action_column()]:
                    n_delted_repetitions += 1
                previous_event = event
        self.log_processor.delete_repetitions()
        lenght_after = len(self.database.get_latest_log())
        self.assertEqual(lenght_before, lenght_after + n_delted_repetitions)
                

    def test_delete_repetitions_event(self):
        actions = self.database.get_actions()
        for action in actions:
            self.setUp()
            lenght_before = len(self.database.get_latest_log())
            n_delted_repetitions = 0
            rawdata = self.database.get_latest_log()
            rawdata_values = rawdata.values
            for trace in self.database.get_traces():

                previous_event = []
                
                for i in self.log_processor.filter_data_by_trace(trace):
                    event = rawdata_values[i, :]
                    if len(previous_event) > 0 and event[self.database.get_action_column()] == action and event[self.database.get_action_column()] ==  previous_event[self.database.get_action_column()]:
                        n_delted_repetitions += 1
                    previous_event = event
            self.log_processor.delete_repetitions_event(action)
            lenght_after = len(self.database.get_latest_log())
            self.assertEqual(lenght_before, lenght_after + n_delted_repetitions)

    def test_delete_repetitions_time(self):
        for time in range(100):
            self.setUp()
            lenght_before = len(self.database.get_latest_log())
            n_delted_repetitions = 0
            rawdata = self.database.get_latest_log()
            rawdata_values = rawdata.values
            for trace in self.database.get_traces():

                previous_appearances = {}
                
                for i in self.log_processor.filter_data_by_trace(trace):
                    event = rawdata_values[i, :]
                    keys_to_delete = []

                    for seen_event in previous_appearances:
                        if (event[self.database.get_timestamp_column()] - previous_appearances[seen_event]) >= time:
                            keys_to_delete.append(seen_event)

                    for key in keys_to_delete:
                        previous_appearances.pop(key)

                    if event[self.database.get_action_column()] in previous_appearances:
                        n_delted_repetitions += 1
                    else:
                        previous_appearances[event[self.database.get_action_column()]] = event[self.database.get_timestamp_column()]
                        
            self.log_processor.delete_repetitions_time(time)
            lenght_after = len(self.database.get_latest_log())
            self.assertEqual(lenght_before, lenght_after + n_delted_repetitions)

    def test_delete_repetitions_event_time(self):
        actions = self.database.get_actions()
        for action in actions:
            for time in range(100):
                self.setUp()
                lenght_before = len(self.database.get_latest_log())
                n_delted_repetitions = 0
                rawdata = self.database.get_latest_log()
                rawdata_values = rawdata.values
                for trace in self.database.get_traces():

                    previous_appearance = None
                    
                    for i in self.log_processor.filter_data_by_trace(trace):
                        event = rawdata_values[i, :]
                        keys_to_delete = []

                        if previous_appearance != None and event[self.database.get_timestamp_column()] - previous_appearance >= time:
                            previous_appearance = None 

                        if event[self.database.get_action_column()] == action:
                            if previous_appearance != None :
                                n_delted_repetitions += 1
                            else:
                                previous_appearance = event[self.database.get_timestamp_column()]
                                
                self.log_processor.delete_repetitions_event_time(action,    time)
                lenght_after = len(self.database.get_latest_log())
                self.assertEqual(lenght_before, lenght_after + n_delted_repetitions)

 


if __name__ == "__main__":
    unittest.main()
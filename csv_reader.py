import datetime
from matplotlib.pyplot import axes
import pandas as pd
from pathlib import Path


class CSVReader:

    def read_data(self, filename, time_string, number_columns, number_rows, separator, timestamp_column, number_chars_timestamp, inseconds):
        data = pd.read_csv(filename, sep=separator, usecols=range(
            number_columns), nrows=number_rows)
        if (not(inseconds)):
            for n, event in enumerate(data.values):
                data.at[n, data.columns[timestamp_column]] = self.convert_to_seconds(
                    event[timestamp_column], time_string, number_chars_timestamp)

        return data.sort_values(data.columns[timestamp_column], axis=0)

    def convert_to_seconds(self, time, time_string, number_chars_timestamp):
        t = datetime.datetime.strptime(time[0:number_chars_timestamp], time_string)
        final_t = (t - datetime.datetime(1900, 1, 1)) / datetime.timedelta(seconds=1)
        return final_t

    def convert_to_datatime(self, time, time_string):
        return datetime.datetime.fromtimestamp(time).strftime(time_string)

    def sort_timestamps(self, data, timestamp_column):
        print(data.head())
        data.sort_values(data.columns[timestamp_column], axis=0)
        return data

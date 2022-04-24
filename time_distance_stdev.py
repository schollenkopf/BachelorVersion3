from time_distance import TimeDistance
import numpy as np
import statistics as stat



class TimeDistanceStdev(TimeDistance):

    def __init__(self, database):
        super().__init__(database)

    def get_name(self) -> str:
        return "Stdev"

    def get_nikname(self) -> str:
        return "StD"
    

    def get_metric(self):
        all_times = self.get_time_between_events()
        actions = self.database.get_actions()
        stdevs = np.zeros((len(actions), len(actions)))
        print("Start")
        for a1 in range(len(actions)):
            for a2 in range(len(actions)):
                
                if len(all_times[a1][a2]) > 1:
                    stdevs[a1, a2] = stat.stdev(all_times[a1][a2]) 
                else: stdevs[a1, a2] = np.inf
        print("End")
        return stdevs  / (self.max(stdevs) - np.min(stdevs))

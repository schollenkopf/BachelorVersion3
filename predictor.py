import numpy as np


class Predictor:

    def __init__(self, list_of_metrics, database):
        self.database = database
        self.metrics = list_of_metrics
        self.hyperparameters = self.init_hyperparameters()
        self.weighted_result = None
        self.weight_of_each_metric = None

    def init_hyperparameters(self):
        hyperparameters = {}
        initial_value = 1/len(self.metrics)
        for metric in self.metrics:
            metric_name = metric.get_name()
            hyperparameters.update({metric_name: initial_value})
        return hyperparameters

    def change_hyperparameter(self, metric_name, new_value):
        self.hyperparameters.update({metric_name: new_value})
        print("changed " + metric_name + " " + str(new_value))

    def adjust_prediction(self):
        pass

    def max(self, array):
        if np.max(array) == np.inf:
            return np.max(array[array < np.inf])
        return np.max(array)

    def predict_sum(self):
        print("init Predict Sum")
        weighted_sum = np.zeros(
            (len(self.database.get_actions()), len(self.database.get_actions())))
        weight_of_each_metric = np.zeros(
            (len(self.metrics), len(self.database.get_actions()), len(self.database.get_actions())))
        for m, metric in enumerate(self.metrics):
            if self.hyperparameters[metric.get_name()] != 0:
                print("calculatin:" + metric.get_name())
                current_metric = metric.get_metric()
                    
                weighted_sum += self.hyperparameters[metric.get_name()] * current_metric
                weight_of_each_metric[m] = current_metric
        self.weight_of_each_metric = weight_of_each_metric

        self.weighted_result = weighted_sum
        print("done")
        
    """
    def predict_product(self):
        weighted_product = np.ones(
            (len(self.database.get_actions()), len(self.database.get_actions())))
        for metric in self.metrics:
            current_metric = metric.get_metric()
            weighted_product = weighted_product * (self.hyperparameters[metric.get_name(
            )] * current_metric / (self.max(current_metric) - np.min(current_metric)))
        self.weighted_result = weighted_product
    """

    def sort_results(self):
        # sort sensor pairs based on average distance
        l = len(self.database.get_actions())
        n = 0
        number_of_pairs = int((l*l)-l)
        pair_labels = np.zeros((2, number_of_pairs), dtype=int)
        pair_array = np.zeros(number_of_pairs)
        weight_of_each_metric_linear = np.zeros((len(self.metrics), number_of_pairs))
        

        for i in range(l):
            for j in range(l):
                if not(j == i):
                    pair_labels[0, n] = i
                    pair_labels[1, n] = j
                    pair_array[n] = self.weighted_result[i, j]
                    for m in range(len(self.metrics)):
                        weight_of_each_metric_linear[m, n] = self.weight_of_each_metric[m, i, j]
                    n = n + 1

        pair_array_indces = np.argsort(pair_array)
        sorted_pair_array = pair_array[pair_array_indces]
        sorted_pair_labels = pair_labels[:, pair_array_indces]
        sorted_weight_of_each_metric_linear = weight_of_each_metric_linear[:, pair_array_indces]

        return sorted_weight_of_each_metric_linear, sorted_pair_labels

# ToDO: only calculate all_times once for all time distance metrics

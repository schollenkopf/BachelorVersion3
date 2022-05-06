import numpy as np

class Metric:

    def get_metric(self) -> np.ndarray:
        pass

    def get_name(self) -> str:
        return "NAME not DEFIEND"

    def get_nikname(self) -> str:
        return "NICKNAME not DEFIEND"

    def max(self, array):
        if np.max(array) == np.inf:
            return np.max(array[array < np.inf])
        return np.max(array)
from abstraction_worker import AbstractionWorker
from PySide6.QtCore import Slot, QObject, QThread, Signal
class CandidateController(QObject):
    
    def __init__(self, abstraction_controller) -> None:
        super().__init__()
        self.abstraction_controller = abstraction_controller
        self.thread = None
        self.worker = None

    updated = Signal(list, int)

    def updater(self):
        candidates = self.abstraction_controller.get_sorted_pair_labels()
        print("Update new Candidates")
        self.updated.emit(candidates, len(candidates) - 1)

    @Slot(int)
    def candidateSelected(self, candidate_index):
        print(f'User clicked on: {candidate_index}')
        self.abstraction_controller.set_pair_we_are_at(candidate_index)
        self.thread = QThread()
        self.worker = AbstractionWorker(self.abstraction_controller)
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run)
        self.worker.finished.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.thread.start()
        self.thread.finished.connect(
            lambda: self.updater()
        )





    





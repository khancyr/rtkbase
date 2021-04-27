from xmlrpc.client import ServerProxy
import supervisor.xmlrpc


class ServiceController(object):
    """
        A simple supervisor commands to manage services
    """

    def __init__(self, unit):
        """
            param: unit: a systemd unit name (ie str2str_tcp...)
        """
        self.unit = unit.split(".")[0]
        self.manager = ServerProxy('http://127.0.0.1',
                                   transport=supervisor.xmlrpc.SupervisorTransport(None, None,
                                                                                   'unix:///tmp/supervisor.sock'))

    def isActive(self):
        if self.manager.supervisor.getProcessInfo(self.unit)["state"] == 20:
            return True
        elif self.manager.supervisor.getProcessInfo(self.unit)["state"] == 10:
            # TODO manage this transitionnal state differently
            return True
        else:
            return False

    def getUser(self):
        return "root"  # TODO : fix this

    def status(self):
        return self.manager.supervisor.getProcessInfo(self.unit)["statename"]

    def status_full(self):
        return str(self.manager.supervisor.getProcessInfo(self.unit))

    def get_log(self):
        return str(self.manager.supervisor.tailProcessLog(self.unit, 0, 2000))

    def start(self):
        self.manager.supervisor.startProcess(self.unit)

    def stop(self):
        self.manager.supervisor.stopProcess(self.unit)

    def restart(self):
        self.stop()
        self.start()

from xmlrpc.client import ServerProxy
import supervisor.xmlrpc


class ServiceController(object):
    """
        A simple supervisor commands to manage services
    """

    manager = ServerProxy('http://127.0.0.1',
                          transport=supervisor.xmlrpc.SupervisorTransport(None, None, 'unix:///tmp/supervisor.sock'))

    def __init__(self, unit):
        """
            param: unit: a systemd unit name (ie str2str_tcp...)
        """
        self.unit = unit.split(".")[0]
        
    def isActive(self):
        if manager.supervisor.getProcessInfo(self.unit)["state"] == 20:
            return True
        elif manager.supervisor.getProcessInfo(self.unit)["state"] == 10:
            #TODO manage this transitionnal state differently
            return True
        else:
            return False

    def getUser(self):
        return "root"  # TODO : fix this
    
    def status(self):
        return manager.supervisor.getProcessInfo(self.unit)["statename"]

    def status_full(self):
        return str(manager.supervisor.getProcessInfo(self.unit))

    def get_log(self):
        return str(manager.supervisor.tailProcessLog(self.unit), 0, 2000)

    def start(self):
        manager.supervisor.startProcess(self.unit)

    def stop(self):
        manager.supervisor.stopProcess(self.unit)

    def restart(self):
        self.stop()
        self.start()

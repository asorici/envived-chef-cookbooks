import sys
from path import path

# set the required paths
PROJECT_ROOT = path(__file__).abspath().dirname().dirname()
SITE_ROOT = PROJECT_ROOT.dirname()

sys.path.insert(0, PROJECT_ROOT)
sys.path.insert(0, PROJECT_ROOT / 'apps')
sys.path.insert(0, PROJECT_ROOT / 'libs')


import settings.development as settings

import django.core.management
django.core.management.setup_environ(settings)
utility = django.core.management.ManagementUtility()
command = utility.fetch_command('runserver')

command.validate()

import django.conf
import django.utils

django.utils.translation.activate(django.conf.settings.LANGUAGE_CODE)


import mod_wsgi

def setup_gcm_logger():
    import logging 
    
    logger = logging.getLogger("c2dm")
    logger.setLevel(logging.INFO)
    
    # fh = logging.FileHandler("c2dm_requests.log")
    fh = logging.StreamHandler()
    fh.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    fh.setFormatter(formatter)
    logger.addHandler(fh)
    
def get_gcm_queue():
    from Queue import Queue
    return Queue(1024)

if mod_wsgi.process_group == 'gcm-jobs':
    gcm_queue = get_gcm_queue()
    setup_gcm_logger()

    import c2dm
    
    c2dm_server_thread = c2dm.GCMServerThread(gcm_queue)
    c2dm_server_thread.start()

    c2dm_client_thread = c2dm.GCMClientThread(gcm_queue)
    c2dm_client_thread.start()

else:
    import django.core.handlers.wsgi
    application = django.core.handlers.wsgi.WSGIHandler()

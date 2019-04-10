#!/usr/bin/python
import os
from notebook.services.contents.filemanager import FileContentsManager
import sys
import json
from nbformat import reads
from base64 import b64decode
import subprocess as sp

NBFORMAT_VERSION = 4
def reads_base64(nb, as_version=NBFORMAT_VERSION):
    """
    Read a notebook from base64.
    """
    return reads(b64decode(nb).decode('utf-8'), as_version=as_version)
def base_model(path):
    return {
        "name": path.rsplit('/', 1)[-1],
        "path": path,
        "writable": True,
        "last_modified": None,
        "created": None,
        "content": None,
        "format": None,
        "mimetype": None,
    }
def notebook_model_from_db(record):
        """
        Build a notebook model from database record.
        """
        path = record['name']
        model = base_model(path)
        model['type'] = 'notebook'
        model['last_modified'] = model['created'] = record['created_timestamp_seconds']
        content = reads_base64(record['content_base64_encoded'])
        model['content'] = content
        model['format'] = 'json'
        return model
abs_dest = sys.argv[1]
abs_dest = "/notebook/{}".format(abs_dest)
if not abs_dest.endswith('.ipynb'):
    abs_dest = "{}.ipynb".format(abs_dest)
with open(abs_dest, 'r') as notebook:
    data = notebook.read()
data = data.replace("'", '"')
data = json.loads(data)
model = notebook_model_from_db(data)
content = FileContentsManager()
content.save(model, '/notebook.ipynb')

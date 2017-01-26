# -*- coding: utf-8 -*-

from os import path, listdir, remove, makedirs
from os.path import isfile, join, basename

import sys
sys.path.insert(0, path.abspath('./packages'))

import argparse
import logging
import requests
import hashlib
import tarfile


REPO_URL = "http://data.lambda3.org/indra/mongodb-3.0"
DATA_DIR = path.abspath("data/mongo/3.0/db")


class Downloader(object):

    def __init__(self, dbdir, repo_url=REPO_URL):
        self.__log = logging.getLogger(self.__class__.__name__)
        self.__repo_url = repo_url
        self.__dbdir = path.abspath(dbdir)

        if isfile(self.__dbdir):
            raise RuntimeError("This path must be a directory '%s'." % self.__dbdir)

        if not path.exists(self.__dbdir):
            makedirs(self.__dbdir)
            #    raise RuntimeError("Can't create data dir '%s'." % self.__dbdir)

        self.__storage = self.__init_storage()

    def download(self, dumps):
        for dump in dumps:
            if dump not in self.__storage:
                datafile = self.__download(dump)
                self.__extract(datafile)
                self.__remove_dump(datafile)
            else:
                self.__log.info("Data for '%s' found. Skipped.", dump)

    def list(self):
        if not self.__storage:
            print("No data found in: '%s'.\n You must download the data first.\n Run with '-h' option." % self.__dbdir)
        for d in self.__storage:
            print(d)

    def __init_storage(self):
        return [f.replace('.ns', '') for f in listdir(self.__dbdir) if f.endswith('.ns') and not f.startswith('local')]

    def __remove_dump(self, datafile):
        self.__log.info("Removing %s", datafile)
        remove("%s.md5" % datafile)
        remove(datafile)

    def __extract(self, compressedfile):
        self.__log.info("Extracting %s ..", basename(compressedfile))
        with tarfile.open(compressedfile) as tar:
            tar.extractall(path=self.__dbdir)
        self.__log.info("%s OK.", basename(compressedfile))

    def __download(self, dump):
        self.__log.info("Downloading data for '%s'", dump)
        md5file, datafile = self.__fetch("%s.tar.gz.md5" % dump), self.__fetch("%s.tar.gz" % dump)
        self.__md5check(md5file, datafile)
        return datafile

    def __fetch(self, targetfname):
        target = join(self.__dbdir, targetfname)

        if path.exists(target):
            self.__log.info("Skipping download: %s", target)
        else:
            url = "%s/%s" % (self.__repo_url, targetfname)
            res = requests.get(url, stream=True)
            res.raise_for_status()
            with open(target, "wb") as handle:
                for chunk in res.iter_content(chunk_size=512):
                    if chunk:
                        handle.write(chunk)

            self.__log.info("'%s' OK.", basename(target))

        return target

    def __md5check(self, md5file, datafile):
        self.__log.info("Verifying integrity of '%s'", basename(datafile))
        md5hash = open(md5file, 'r').read().split()[0]

        def md5(fname):
            hash_md5 = hashlib.md5()
            with open(fname, "rb") as f:
                for chunk in iter(lambda: f.read(4096), b""):
                    hash_md5.update(chunk)
            return hash_md5.hexdigest()

        if md5hash != md5(datafile):
            raise RuntimeError("Checksum differs! Data may be corrupted.")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dumps", metavar="dump-name",
                        help="Download the dump if missing.", action='append')

    args = parser.parse_args()

    d = Downloader(DATA_DIR)

    if args.dumps:
        d.download(args.dumps)
    else:
        d.list()

if __name__ == "__main__":
    logging.basicConfig(format='%(asctime)s [%(levelname)s] %(message)s', level=logging.INFO)
    main()



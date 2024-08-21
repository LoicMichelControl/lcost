#! /usr/bin/python3
# -*- coding: UTF-8 -*-
#-----------------------------------------------------------------------------------------
#   Building Openfast, executable and libs - prepared by Pierre Molinaro 
#-----------------------------------------------------------------------------------------
# https://openfast.readthedocs.io/en/main/source/install/index.html#compile-from-source
# AVANT DE LANCER LE SCRIPT : instal homebrew
#
#-----------------------------------------------------------------------------------------
#   Imports
#-----------------------------------------------------------------------------------------

import time
import subprocess, sys, os
import shutil
import subprocess
import platform
import multiprocessing

#-----------------------------------------------------------------------------------------
#   processorCount
#-----------------------------------------------------------------------------------------

def processorCount () :
  return str (multiprocessing.cpu_count () + 1)

#-----------------------------------------------------------------------------------------
#   FOR PRINTING IN COLOR
#-----------------------------------------------------------------------------------------

class bcolors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    BOLD_BLUE = '\033[1m' + '\033[94m'
    BOLD_GREEN = '\033[1m' + '\033[92m'
    BOLD_RED = '\033[1m' + '\033[91m'

#-----------------------------------------------------------------------------------------
#   myChDir
#-----------------------------------------------------------------------------------------

def myChDir (dir):
  print (bcolors.BOLD_BLUE + "+ chdir " + dir + bcolors.ENDC)
  os.chdir (dir)

#-----------------------------------------------------------------------------------------
#   COPY TREE
#-----------------------------------------------------------------------------------------
# http://stackoverflow.com/questions/1868714/how-do-i-copy-an-entire-directory-of-files-into-an-existing-directory-using-pyth

def myCopyTree (src, dst):
  print (bcolors.BOLD_BLUE + "+ copytree " + src + " " + dst + bcolors.ENDC)
  for item in os.listdir (src):
    s = os.path.join (src, item)
    d = os.path.join (dst, item)
    if os.path.isdir (s):
      if not os.path.exists (d):
        os.mkdir (d)
      myCopyTree (s, d)
    else:
      shutil.copy2 (s, d)

#-----------------------------------------------------------------------------------------
#   myDeleteDir
#-----------------------------------------------------------------------------------------
# http://unix.stackexchange.com/questions/77127/rm-rf-all-files-and-all-hidden-files-without-error
# http://unix.stackexchange.com/questions/233576/recursively-delete-subdirectories-not-containing-pattern-on-osx

def myDeleteDir (dir):
  # while os.path.exists (dir):
    print (bcolors.BOLD_BLUE + "+ remove '" + dir + "' directory" + bcolors.ENDC)
  #  shutil.rmtree (dir, True) # Ignore errors

#-----------------------------------------------------------------------------------------
#   runHiddenCommand
#-----------------------------------------------------------------------------------------

def runHiddenCommand (cmd, logUtilityTool=False) :
  result = ""
  childProcess = subprocess.Popen (cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
  while True:
    line = childProcess.stdout.readline ()
    if line != "":
      result += line
    else:
      childProcess.wait ()
      if childProcess.returncode != 0 :
        print (bcolors.BOLD_RED + "Erreur " + str (childProcess.returncode) + bcolors.ENDC)
        sys.exit (childProcess.returncode)
      return result

#-----------------------------------------------------------------------------------------
#   runCommand
#-----------------------------------------------------------------------------------------

def runCommand (cmd, environnement=None) :
  string = "+"
  for s in cmd:
    if " " in s :
      string += " '" + s + "'"
    else:
      string += " " + s
  print (bcolors.BOLD_BLUE + string + bcolors.ENDC)
  childProcess = subprocess.Popen (cmd, env=environnement)
  childProcess.wait ()
  if childProcess.returncode != 0 :
    print (bcolors.BOLD_RED + "Erreur " + str (childProcess.returncode) + bcolors.ENDC)
    sys.exit (childProcess.returncode)

#-----------------------------------------------------------------------------------------
#   ARCHIVE DOWNLOAD
#-----------------------------------------------------------------------------------------

def downloadArchive (archiveURL, archivePath, startTime):
  if not os.path.exists (archivePath):
    print (bcolors.BOLD_BLUE + "+Download " + os.path.basename (archivePath) + bcolors.ENDC)
    print ("URL '" + archiveURL + "'")
    runCommand (["curl", "-L", archiveURL, "-o", archivePath])

#-----------------------------------------------------------------------------------------
#   displayDurationFromStartTime
#-----------------------------------------------------------------------------------------

def displayDurationFromStartTime (startTime) :
  totalDurationInSeconds = int (time.time () - startTime)
  durationInSecondes = int (totalDurationInSeconds % 60)
  durationInMinutes = int ((totalDurationInSeconds / 60) % 60)
  durationInHours = int (totalDurationInSeconds / 3600)
  s = ""
  if durationInHours > 0:
    s += str (durationInHours) + " h"
  if durationInMinutes > 0:
    s += " " + str (durationInMinutes) + " min"
  s += " " + str (durationInSecondes) + " s"
  print ("Done at +" + s)

#-----------------------------------------------------------------------------------------
#  BREW check or install
#-----------------------------------------------------------------------------------------

def brewCheckOrInstall (package) :
  print (bcolors.BOLD_GREEN + "--- Check brew package installed: " + package + bcolors.ENDC)
  if not os.path.exists ("/usr/local/Cellar/" + package) :
    runCommand (["brew", "install", package])

#-----------------------------------------------------------------------------------------
#  BREW check package not installed
#-----------------------------------------------------------------------------------------

def brewCheckNotInstalled (package) :
  print (bcolors.BOLD_GREEN + "--- Check brew package not installed: " + package + bcolors.ENDC)
  if os.path.exists ("/usr/local/Cellar/" + package) :
    print (bcolors.BOLD_RED + "Erreur, il faut désinstaller le package brew '" + package + "' : 'brew uninstall " + package + "'" + bcolors.ENDC)
    sys.exit (1)

#-----------------------------------------------------------------------------------------
#  build GCC
#-----------------------------------------------------------------------------------------

def build_GCC (ARCHIVE_DIR, UTILITY_DIR, startTime, scriptDir) :
  GCC_VERSION  = "14.1.0" # "13.2.0"
  GMP_VERSION  = "6.2.1"
  MPFR_VERSION = "4.1.0"
  MPC_VERSION  = "1.2.1"
  ISL_VERSION  = "0.24"
  #--- Download GCC archive
  GCC = "gcc-" + GCC_VERSION
  GCC_ARCHIVE_PATH = ARCHIVE_DIR + "/" + GCC + ".tar.xz"
  downloadArchive ("ftp://ftp.gnu.org/gnu/gcc/gcc-" + GCC_VERSION + "/" + GCC + ".tar.xz", GCC_ARCHIVE_PATH, startTime)
  #--- Download GMP archive
  GMP = "gmp-" + GMP_VERSION
  GMP_ARCHIVE_PATH = ARCHIVE_DIR + "/" + GMP + ".tar.bz2"
  downloadArchive ("ftp://ftp.gnu.org/gnu/gmp/" + GMP + ".tar.bz2", GMP_ARCHIVE_PATH, startTime)
  #--- Download MPFR archive
  MPFR = "mpfr-" + MPFR_VERSION
  MPFR_ARCHIVE_PATH = ARCHIVE_DIR + "/" + MPFR + ".tar.bz2"
  downloadArchive ("ftp://ftp.gnu.org/gnu/mpfr/" + MPFR + ".tar.bz2", MPFR_ARCHIVE_PATH, startTime)
  #--- Download MPC archive
  MPC    = "mpc-" + MPC_VERSION
  MPC_ARCHIVE_PATH = ARCHIVE_DIR + "/" + MPC + ".tar.gz"
  downloadArchive ("https://ftp.gnu.org/gnu/mpc/" + MPC + ".tar.gz", MPC_ARCHIVE_PATH, startTime)
  #--- Download ISL archive https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2
  ISL = "isl-" + ISL_VERSION
  ISL_ARCHIVE_PATH = ARCHIVE_DIR + "/" + ISL + ".tar.bz2"
  downloadArchive ("https://gcc.gnu.org/pub/gcc/infrastructure/" + ISL + ".tar.bz2", ISL_ARCHIVE_PATH, startTime)
  #--- build
  print (bcolors.BOLD_GREEN + "-------------- GCC" + bcolors.ENDC)
  if not os.path.exists (UTILITY_DIR + "/bin/gcc"):
    myDeleteDir (GCC)
    myDeleteDir ("build-gcc")
    runCommand (["cp", GCC_ARCHIVE_PATH, GCC + ".tar.xz"])
    runCommand (["tar", "xf", GCC + ".tar.xz"])
    runCommand (["rm", GCC + ".tar.xz"])
    #--- GMP
    runCommand (["cp", GMP_ARCHIVE_PATH, GMP + ".tar.bz2"])
    runCommand (["tar", "xf", GMP + ".tar.bz2"])
    runCommand (["rm", GMP + ".tar.bz2"])
    runCommand (["mv", GMP, GCC + "/gmp"])
    #--- MPFR
    runCommand (["cp", MPFR_ARCHIVE_PATH,  MPFR + ".tar.bz2"])
    runCommand (["tar", "xf", MPFR + ".tar.bz2"])
    runCommand (["rm", MPFR + ".tar.bz2"])
    runCommand (["mv", MPFR, GCC + "/mpfr"])
    #--- MPC
    runCommand (["cp", MPC_ARCHIVE_PATH, MPC + ".tar.gz"])
    runCommand (["tar", "xf", MPC + ".tar.gz"])
    runCommand (["rm", MPC + ".tar.gz"])
    runCommand (["mv", MPC, GCC + "/mpc"])
    #--- ISL
    runCommand (["cp", ISL_ARCHIVE_PATH,  ISL + ".tar.bz2"])
    runCommand (["tar", "xf", ISL + ".tar.bz2"])
    runCommand (["rm", ISL + ".tar.bz2"])
    runCommand (["mv", ISL, GCC + "/isl"])

    runCommand (["mkdir", "build-gcc"])
    myChDir (scriptDir + "/build-gcc")
    runCommand (["../" + GCC + "/configure", "--help"])
    runCommand (["../" + GCC + "/configure", "--prefix=" + UTILITY_DIR])
    runCommand (["make", "all", "-j" + processorCount ()])
    runCommand (["make", "install"])
    myChDir (scriptDir)
    myDeleteDir ("build-gcc")
    myDeleteDir (GCC)
  return UTILITY_DIR

#-----------------------------------------------------------------------------------------
#  build CMAKE
#-----------------------------------------------------------------------------------------

def buildCMAKE (ARCHIVE_DIR, UTILITY_DIR, startTime, scriptDir) :
  CMAKE_UTILITY = UTILITY_DIR + "/bin/cmake"
  #--- Download archive
  CMAKE_VERSION = "3.27.6" # https://github.com/Kitware/CMake/releases
  CMAKE = "cmake-" + CMAKE_VERSION
  CMAKE_ARCHIVE_PATH = ARCHIVE_DIR + "/" + CMAKE + ".tar.gz"
  downloadArchive ("https://github.com/Kitware/CMake/releases/download/v" + CMAKE_VERSION + "/" + CMAKE + ".tar.gz", CMAKE_ARCHIVE_PATH, startTime)
  #--- build
  print (bcolors.BOLD_GREEN + "-------------- CMAKE" + bcolors.ENDC)
  if not os.path.exists (CMAKE_UTILITY):
    runCommand (["rm", "-fr", CMAKE, "build-cmake"])
    runCommand (["cp", CMAKE_ARCHIVE_PATH, CMAKE + ".tar.gz"])
    runCommand (["tar", "xf", CMAKE + ".tar.gz"])
    runCommand (["rm", CMAKE + ".tar.gz"])
    runCommand (["mkdir", "build-cmake"])
    myChDir (scriptDir + "/build-cmake")
  #  runCommand (["../" + CMAKE + "/bootstrap", "--help"])
    runCommand (["../" + CMAKE + "/bootstrap", "--prefix=" + UTILITY_DIR])
    runCommand (["make", "all", "-j" + processorCount ()])
    runCommand (["make", "install"])
    myChDir (scriptDir)
    myDeleteDir ("build-cmake")
    myDeleteDir (CMAKE)
  return CMAKE_UTILITY

#-----------------------------------------------------------------------------------------
#  build OPEN MPI
# https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.6.tar.bz2
#-----------------------------------------------------------------------------------------

def build_OPEN_MPI (ARCHIVE_DIR, UTILITY_DIR, startTime, scriptDir) :
  OPENMPI_UTILITY = UTILITY_DIR + "/bin/mpiexec"
  #--- Download archive (initial 5.0.0)
  OPENMPI_VERSION = "5.0.3"
  OPENMPI = "openmpi-" + OPENMPI_VERSION
  OPENMPI_ARCHIVE_PATH = ARCHIVE_DIR + "/" + OPENMPI + ".tar.gz"
  downloadArchive ("https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-" + OPENMPI_VERSION + ".tar.gz", OPENMPI_ARCHIVE_PATH, startTime)
  #--- build
  print (bcolors.BOLD_GREEN + "-------------- OPENMPI" + bcolors.ENDC)
  if not os.path.exists (OPENMPI_UTILITY):
    runCommand (["rm", "-fr", OPENMPI, "build-openmpi"])
    runCommand (["cp", OPENMPI_ARCHIVE_PATH, OPENMPI + ".tar.bz2"])
    runCommand (["tar", "xf", OPENMPI + ".tar.bz2"])
    runCommand (["rm", OPENMPI + ".tar.bz2"])
    runCommand (["mkdir", "build-openmpi"])
    myChDir (scriptDir + "/build-openmpi")
 #   runCommand (["../" + OPENMPI + "/configure", "--help"])
    configureOptions = ["--prefix=" + UTILITY_DIR]
    configureOptions += ["CC=/usr/local/Cellar/gcc/14.1.0_2/bin/gcc-14"]
    configureOptions += ["CXX=/usr/local/Cellar/gcc/14.1.0_2/bin/g++-14"]
    runCommand (["../" + OPENMPI + "/configure"] + configureOptions)
    runCommand (["make", "all", "-j" + processorCount ()])
    runCommand (["make", "install"])
    myChDir (scriptDir)
    myDeleteDir ("build-openmpi")
    myDeleteDir (OPENMPI)
  return OPENMPI_UTILITY

#-----------------------------------------------------------------------------------------
#  build YAML-CPP
#-----------------------------------------------------------------------------------------

def build_YAMLCPP (ARCHIVE_DIR, UTILITY_DIR, startTime, scriptDir, CMAKE_UTILITY) :
  print (bcolors.BOLD_GREEN + "-------------- YAML-CPP" + bcolors.ENDC)
  #--------------------------------------------------------------------------- archive
  YAMLCPP_VERSION = "0.8.0"
  YAMLCPP = "yaml-cpp-" + YAMLCPP_VERSION
  YAMLCPP_ARCHIVE_PATH = ARCHIVE_DIR + "/" + YAMLCPP + ".tar.gz"
  #--- Téléchargement # https://github.com/jbeder/yaml-cpp/archive/refs/tags/0.8.0.tar.gz
  BASE_URL = "https://github.com/jbeder/yaml-cpp/archive/refs/tags/"
  YAMLCPP_URL = BASE_URL + YAMLCPP_VERSION + ".tar.gz"
  downloadArchive (YAMLCPP_URL, YAMLCPP_ARCHIVE_PATH, startTime)
  #--- Open fast
  myDeleteDir (YAMLCPP)
  if not os.path.exists (UTILITY_DIR + "/lib/libyaml-cpp.a"):
    runCommand (["cp", ARCHIVE_DIR + "/" + YAMLCPP + ".tar.gz", YAMLCPP + ".tar.gz"])
    runCommand (["tar", "xf", YAMLCPP + ".tar.gz"])
    runCommand (["rm", "-f", YAMLCPP + ".tar.gz"])
    runCommand (["mkdir", YAMLCPP + "/build"])
    myChDir (YAMLCPP + "/build")
    cmakeOptions  = []
    cmakeOptions += ["-DCMAKE_CXX_COMPILER=/usr/local/Cellar/gcc/14.1.0_2/bin/g++-14;-Wl,-ld_classic"]
    # https://stackoverflow.com/questions/48825416/missing-openmp-c-flags-openmp-c-lib-names
    #--- Avec cette option, la durée de compilation de openfast est divisée par 3,
    # mais le code est peu optimisé
    cmakeOptions += ["-DCMAKE_BUILD_TYPE=MinSizeRel"]
  #  cmakeOptions += ["-DCMAKE_BUILD_TYPE=Debug"]
    #--- CMAKE verbose ?
    cmakeOptions += ["-DCMAKE_VERBOSE_MAKEFILE=ON"]
    #--- CMAKE
    runCommand ([CMAKE_UTILITY, "--version"])
    runCommand ([CMAKE_UTILITY, "..", "-DCMAKE_INSTALL_PREFIX=" + UTILITY_DIR] + cmakeOptions)
    runCommand (["make", "help"])
    runCommand (["make", "-j" + processorCount ()])
    runCommand (["make", "install"])
    myChDir (scriptDir)
    myDeleteDir (YAMLCPP)

#-----------------------------------------------------------------------------------------
#  build OPENFAST
#-----------------------------------------------------------------------------------------

def build_OPENFAST (ARCHIVE_DIR, UTILITY_DIR, startTime, scriptDir, INSTALL_DIR, CMAKE_UTILITY, OPENFAST_VERSION) :
  print (bcolors.BOLD_GREEN + "-------------- Openfast" + bcolors.ENDC)
  #--------------------------------------------------------------------------- Openfast archive
  OPENFAST = "openfast-" + OPENFAST_VERSION
  OPENFAST_ARCHIVE_PATH = ARCHIVE_DIR + "/" + OPENFAST + ".tar.gz"
  #--- Téléchargement
  BASE_URL = "https://github.com/OpenFAST/openfast/archive/refs/tags/v"
  OPENFAST_URL = BASE_URL + OPENFAST_VERSION + ".tar.gz"
  downloadArchive (OPENFAST_URL, OPENFAST_ARCHIVE_PATH, startTime)

# git clone -b v2.6.0 https://github.com/OpenFAST/openfast.git ./openFAST_260

  #--- Open fast
  myDeleteDir (OPENFAST)
  if not os.path.exists (INSTALL_DIR + "/include/SC.h"):
#    runCommand (["cp", ARCHIVE_DIR + "/" + OPENFAST + ".tar.gz", OPENFAST + ".tar.gz"])
#    runCommand (["tar", "xf", OPENFAST + ".tar.gz"])
#    runCommand (["rm", "-f", OPENFAST + ".tar.gz"])
#     YAMLCPP_VERSION = "0.8.0"
#     YAMLCPP = "yaml-cpp-" + YAMLCPP_VERSION
#     runCommand (["cp", ARCHIVE_DIR + "/" + YAMLCPP + ".tar.gz", YAMLCPP + ".tar.gz"])
#     runCommand (["tar", "xf", YAMLCPP + ".tar.gz"])
#     runCommand (["rm", "-f", YAMLCPP + ".tar.gz"])
#    runCommand (["mv", YAMLCPP, OPENFAST + "/modules"])

    runCommand(["git", "clone", "-b", "v3.5.3", "https://github.com/OpenFAST/openfast.git", "./openfast-3.5.3"])
    runCommand (["mkdir", OPENFAST + "/build"])
    myChDir (OPENFAST + "/build")
    cmakeOptions  = []
    #--- Demande la construction de l'API C++ ou Simulink -> OpenMP et MPI sont nécessaires
   
    # ne pas utiliser avec 3.5.1 car compliqué d'utiliser la librarie
    #cmakeOptions += ["-DBUILD_OPENFAST_CPP_API=ON"]
    #cmakeOptions += ["-DBUILD_SHARED_LIBS=ON"]
    
    # OK pour API Simulink
    cmakeOptions += ["-DBUILD_OPENFAST_SIMULINK_API=ON"]
    cmakeOptions += ["-DMatlab_ROOT_DIR=/Applications/MATLAB_R2023b.app"]
    
    cmakeOptions += ["-DCMAKE_OSX_DEPLOYMENT_TARGET=14.0"]
    #---
    #cmakeOptions += ["-DCMAKE_Fortran_COMPILER=/usr/local/Cellar/gcc/13.2.0/bin/gfortran"]
    cmakeOptions += ["-DCMAKE_Fortran_COMPILER=/usr/local/Cellar/gcc/14.1.0_2/bin/gfortran"]
    cmakeOptions += ["-DCMAKE_C_COMPILER=/usr/local/Cellar/gcc/14.1.0_2/bin/gcc-14"]
    cmakeOptions += ["-DCMAKE_CXX_COMPILER=/usr/local/Cellar/gcc/14.1.0_2/bin/g++-14;-Wl,-ld_classic;-Wl,-L" + UTILITY_DIR + "/lib"]
    # https://stackoverflow.com/questions/48825416/missing-openmp-c-flags-openmp-c-lib-names
    #--- OpenMP
#     cmakeOptions += ["-DOPENMP=ON"] # Est-ce indispensable ?
#     cmakeOptions += ["-DOpenMP_C_FLAGS=-fopenmp"]
#     cmakeOptions += ["-DOpenMP_C_LIB_NAMES=libomp;libgomp;libiomp5"]
#     cmakeOptions += ["-DOpenMP_CXX_FLAGS=-fopenmp"]
#     cmakeOptions += ["-DOpenMP_CXX_LIB_NAMES=libomp;libgomp;libiomp5"]
#     cmakeOptions += ["-DOpenMP_libomp_LIBRARY=libomp"]
#     cmakeOptions += ["-DOpenMP_libgomp_LIBRARY=libgomp"]
#     cmakeOptions += ["-DOpenMP_libiomp5_LIBRARY=libiomp5"]
    #--- MPI
    # https://cmake.org/cmake/help/latest/module/FindMPI.html
    cmakeOptions += ["-DMPIEXEC_EXECUTABLE=" + UTILITY_DIR + "/bin/mpiexec"]
    #--- HDF5 est trouvé automatiquement /usr/local/Cellar/hdf5
    #--- YAML-CPP
    cmakeOptions += ["-DCMAKE_PREFIX_PATH=" + UTILITY_DIR]
    #--- Avec cette option, la durée de compilation de openfast est divisée par 3, mais le code est peu optimisé
    cmakeOptions += ["-DCMAKE_BUILD_TYPE=MinSizeRel"] # Debug
    #--- CMAKE verbose ?
    cmakeOptions += ["-DCMAKE_VERBOSE_MAKEFILE=ON"]
    #--- CMAKE
    runCommand ([CMAKE_UTILITY, "--version"])
    runCommand ([CMAKE_UTILITY, "..", "-DCMAKE_INSTALL_PREFIX=" + INSTALL_DIR] + cmakeOptions)
    runCommand (["make", "help"])
    runCommand (["make", "-j" + processorCount ()])
    runCommand (["make", "install"])
    myChDir (scriptDir)
    myDeleteDir (OPENFAST)

#-----------------------------------------------------------------------------------------
#  buildDistribution
#-----------------------------------------------------------------------------------------

def buildDistribution (OPENFAST_VERSION) :
  startTime = time.time ()
  #--------------------------------------------------------------------------- Get platform
  PLATFORM_OPTIONS = []
  systemName = platform.system ()
  print ("System: " + systemName)
  machine = platform.machine ()
  print ("Machine: " + machine)
  #--------------------------------------------------------------------------- Get script absolute path
  scriptDir = os.path.dirname (os.path.abspath (sys.argv [0]))
  myChDir (scriptDir)
  #--------------------------------------------------------------------------- brew
  brewCheckOrInstall ("cmake")
  brewCheckOrInstall ("openblas")
  brewCheckOrInstall ("gcc")
  brewCheckOrInstall ("libomp")
  brewCheckOrInstall ("llvm")
  brewCheckOrInstall ("hdf5")
  brewCheckNotInstalled ("openmpi")
  brewCheckNotInstalled ("yaml-cpp")
  #--------------------------------------------------------------------------- Directories
  ARCHIVE_DIR = os.path.abspath (scriptDir + "/+archives")
  runCommand (["mkdir", "-p", ARCHIVE_DIR])
  UTILITY_DIR = os.path.abspath (scriptDir + "/utilities")
  #--------------------------------------------------------------------------- CMAKE
  # CMAKE_UTILITY = buildCMAKE (ARCHIVE_DIR, UTILITY_DIR, startTime, scriptDir)
  CMAKE_UTILITY = "/usr/local/bin/cmake"
  #--------------------------------------------------------------------------- GCC
  #GCC_DIR = build_GCC (ARCHIVE_DIR, UTILITY_DIR, startTime, scriptDir)
  #--------------------------------------------------------------------------- OPENMPI
  OPENMPI_LIB_DIR = build_OPEN_MPI (ARCHIVE_DIR, UTILITY_DIR, startTime, scriptDir)
  #--------------------------------------------------------------------------- YAML-CPP
  build_YAMLCPP (ARCHIVE_DIR, UTILITY_DIR, startTime, scriptDir, CMAKE_UTILITY)
  #--------------------------------------------------------------------------- Product
  PRODUCT_NAME  = "product-openfast-library-" + OPENFAST_VERSION
  INSTALL_DIR = scriptDir + "/" + PRODUCT_NAME
  #--------------------------------------------------------------------------- Openfast
  build_OPENFAST (ARCHIVE_DIR, UTILITY_DIR, startTime, scriptDir, INSTALL_DIR, CMAKE_UTILITY, OPENFAST_VERSION)
  #--------------------------------------------------------------------------- Check executables
  print (bcolors.BOLD_GREEN + "-------------- Success!" + bcolors.ENDC)
  runCommand ([INSTALL_DIR + "/bin/openfast", "-v"])
  runCommand ([INSTALL_DIR + "/bin/hydrodyn_driver", "-v"])
  displayDurationFromStartTime (startTime)

#-----------------------------------------------------------------------------------------
#  MAIN
#-----------------------------------------------------------------------------------------

buildDistribution ("3.5.3")

#-----------------------------------------------------------------------------------------

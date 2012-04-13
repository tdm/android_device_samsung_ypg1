#
# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os, sys

LOCAL_DIR = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
RELEASETOOLS_DIR = os.path.abspath(os.path.join(LOCAL_DIR, '../../../build/tools/releasetools'))
VENDOR_SAMSUNG_DIR = os.path.abspath(os.path.join(LOCAL_DIR, '../../../vendor/samsung'))

import edify_generator

class EdifyGenerator(edify_generator.EdifyGenerator):
    def UpdateKernel(self):
#      self.script.append('ui_print("Checking state of filesystems...");')
#
#      self.script.append(
#            ('package_extract_file("make_ext4fs", "/tmp/make_ext4fs");\n'
#             'set_perm(0, 0, 0755, "/tmp/make_ext4fs");'))
#
#      self.script.append(
#            ('package_extract_file("busybox", "/tmp/busybox");\n'
#             'set_perm(0, 0, 0755, "/tmp/busybox");'))
#
#      self.script.append(
#            ('package_extract_file("fsconvert.sh", "/tmp/fsconvert.sh");\n'
#             'set_perm(0, 0, 0755, "/tmp/fsconvert.sh");'))
#
#      self.script.append('assert(run_program("/tmp/fsconvert.sh") == 0);')

      self.script.append('package_extract_file("kernel", "/tmp/kernel");')
      self.script.append('package_extract_file("kernel-XAA", "/tmp/kernel-XAA");')

      self.script.append(
            ('package_extract_file("flash_kernel", "/tmp/flash_kernel");\n'
             'set_perm(0, 0, 0755, "/tmp/flash_kernel");'))

      self.script.append(
            ('package_extract_file("updatekernel.sh", "/tmp/updatekernel.sh");\n'
             'set_perm(0, 0, 0755, "/tmp/updatekernel.sh");'))

      self.script.append('assert(run_program("/tmp/updatekernel.sh") == 0);')

    def CopyEfsData(self):
      self.script.append(
            ('package_extract_file("copyefsdata.sh", "/tmp/copyefsdata.sh");\n'
             'set_perm(0, 0, 0755, "/tmp/copyefsdata.sh");'))

      self.script.append('assert(run_program("/tmp/copyefsdata.sh") == 0);')

    def RunBackup(self, command):
      edify_generator.EdifyGenerator.RunBackup(self, command)

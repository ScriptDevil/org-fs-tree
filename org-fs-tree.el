;;; org-fs-tree.el --- converts filesystem trees to org trees

;; Copyright (C) 2015 Ashok Gautham Jadatharan

;; Author: Ashok Gautham Jadatharan <ScriptDevil@zoho.com>
;; Version: 0.1.0
;; Package-Requires: ((f "0") (names "0"))
;; Keywords: org-mode

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; converts filesystem trees to org trees
;;
;; See documentation on https://github.com/ScriptDevil/org-fs-tree

;;; Code:
(require 'f)
(require 'names)

(define-namespace org-fs-tree-

(defun -make-link (s link)
  (concat "[[" link "][" s "]]"))

(defun -make-heading (s level)
  (concat (make-string level ?*) " " s "\n"))

(defun -create-tree (base-dir level)
  (let* ((full-path (f-full base-dir))
	 (short-name  (if (f-dir? base-dir)
			  (concat (f-filename base-dir) "/")
			(f-filename base-dir)))
	 (link (-make-link short-name full-path))
	 (heading (-make-heading link level)))
    (if (f-directory? base-dir)
	(concat heading
		(apply 'concat (mapcar
				(lambda (d)  (-create-tree d (+ 1 level)))
				(f-entries base-dir))))
      heading)))  

(defun dump (dirname)
  "Dump the file system tree rooted at DIRNAME as an org tree.
Each heading in the org-tree will be a link to the corresponding
file or directory that can be opened using org-open-at-point
"

  (interactive "DDirectory to dump: ")
  (insert (-create-tree dirname 1)))
)

(provide 'org-fs-tree)

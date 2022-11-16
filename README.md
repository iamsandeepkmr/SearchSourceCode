# Search Source Code
This is a simple project in PowerShell which can scan through your source code to search for a specific text in each source file and shows you the results (in console and a text file report).

The biggest use case for me was to know if my project source code is IPR (Intellectual Property Rights) compliant. IPR header is a proprietary text put on top of each source file in a project (as a comment). If any of the source code file is not IPR compliant, the build pipeline should fail and tell the list of files which are not IPR compliant.

This PowerShell script can be used as a task in DevOps pipeline to scan through the source code and search for a specific text (IPR header in my case) in each file. You can use this script for other similar requirements.

## Input to the script
- **Source Code Path:** Your source code path to scan. Eg. "D:\SourceCode\ProjectABC". Use "$(System.DefaultWorkingDirectory)" if running the script as a task in DevOps pipeline
- **Text:** Text (part or full) to search for in your source code. Text should be a single line. Eg. "COMPANY XYZ PROPRIETARY. This document and its accompanying elements, contain information which is proprietary and confidential"
- **Files to Include:** Extension of source code files to consider for scanning. Eg. "*.cs, *.ts, *.html, *.htm"
- **Folders to Exclude:** Folders to skip from scanning. Eg. "bin, obj, node_modules, dist"
-  **Output File:** Path to a file to report the search results. Eg. "D:\SourceCode\ProjectABC\IPRReport.txt". Make use of "$(Build.ArtifactStagingDirectory)" if running the script as a task in DevOps pipeline. Eg. "$(Build.ArtifactStagingDirectory)/IPRReport.txt"

## Script
Refer SearchSourceCode.ps1 from the repository

## Run the Script
I am going to use this script in my project to find the source code files with missing IPR header.

**Use below command to run the script**

![image](https://user-images.githubusercontent.com/42836797/202135464-37335948-3d1f-4c3d-a1d6-84acd6db7a39.png)

**Output**

![image](https://user-images.githubusercontent.com/42836797/202139326-1ac5a1ba-47ad-4869-9aa7-18f5761c0d7d.png)

This is how the IPR report will look like:

![image](https://user-images.githubusercontent.com/42836797/202139809-233ec3de-c534-44fb-8beb-e3a0de8c8ac5.png)

## Use the Script as a DevOps pipeline task
- **Add a PowerShell task in your pipeline**
- **Copy the PowerShell script (Inline). Specify/modify input values**
- **Add below code if you want to fail the pipeline in case there are files with missing IPR header**
  ```
  if($fileCountWithoutText -gt 0) {
      exit 1
  }
  ```
![image](https://user-images.githubusercontent.com/42836797/202144543-42bcdde1-9a15-4a5e-bc20-26241366d6eb.png)

- **Don't forget to publish the report as a pipeline artifact in a separate task (or as a part of an existing publish artifacts task in your pipeline)**

- **Run the pipeline**

**Output**

Pipeline task output:

![image](https://user-images.githubusercontent.com/42836797/202148716-24f154ad-3cc1-42f4-bbc0-228be0dc4b74.png)
There are no files with missing IPR header in my source code.

Report in pipeline artifacts:

![image](https://user-images.githubusercontent.com/42836797/202149265-53726503-9962-4c9c-b5d5-0c2f35d0a608.png)

![image](https://user-images.githubusercontent.com/42836797/202150148-3d787d64-4516-4f89-82f1-db51a47f3ce7.png)

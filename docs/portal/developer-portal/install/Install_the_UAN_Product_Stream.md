## Install the UAN Product Stream

Install the User Access Nodes \(UAN\) product and then verify the installation.

- The Cray command line interface \(CLI\) tool is initialized and configured on the system. See "Configure the Cray Command Line Interface \(CLI\)" in the CSM documentation for more information.
- [Prepare for UAN Product Installation](Prepare_for_UAN_Product_Installation.md)

- **OBJECTIVE**

    Install the User Access Nodes \(UAN\) product on a system so that UAN boot images can be created.

Replace PRODUCT\_VERSION in the example commands with the UAN product stream string \(2.0.0 for example\). Replace CRAY\_EX\_DOMAIN in the example commands with the FQDN of the HPE Cray EX.

**DOWNLOAD AND PREPARE THE UAN SOFTWARE PACKAGE**

1. Start a typescript to capture the commands and output from this installation.

    ```bash
    ncn-m001# script -af product-uan.$(date +%Y-%m-%d).txt 
    ncn-m001# export PS1='\u@\H \D{%Y-%m-%d} \t \w # '
    ```

2. Run the installation script using either one of the following commands:

    - If the HPE Cray EX is configured for online installations, run this command:

        ```bash
        ncn-m001# ./install.sh --online
        ```

    - If the HPE Cray EX is configured for offline \(that is, air-gapped\) installations, run this command:

        ```bash
        ncn-m001# ./install.sh
        ```

**VERIFY THE INSTALLATION**

3. Verify that the UAN configuration, images, and recipes have been imported and added to the cray-product-catalog ConfigMap in the Kubernetes `services` namespace.

    1. Run the following command and verify that the output contains an entry for the PRODUCT\_VERSION that was installed in the previous steps:

        The following command may return more than one version of the UAN product if previous versions have been installed.

        ```bash
        ncn-m001# kubectl get cm cray-product-catalog -n services -o json | jq -r .data.uan
        PRODUCT_VERSION:
             configuration:
               clone_url: https://vcs.CRAY_EX_DOMAIN/vcs/cray/uan-config-management.git
               commit: 6658ea9e75f5f0f73f78941202664e9631a63726
               import_branch: cray/uan/PRODUCT_VERSION
               import_date: 2021-07-28 03:26:00.399670
               ssh_url: git@vcs.CRAY_EX_DOMAIN:cray/uan-config-management.git
             images:
               cray-shasta-uan-cos-sles15sp1.x86_64-0.1.17:
                 id: c880251d-b275-463f-8279-e6033f61578b
             recipes:
               cray-shasta-uan-cos-sles15sp1.x86_64-0.1.17:
                 id: cbd5cdf6-eac3-47e6-ace4-aa1aecb1359a
        ```

    2. Verify that the configuration, images, and recipes sections for the installed product version contain information similar to the example output in the previous command.

    3. Check the Kubernetes jobs responsible for importing the configuration, image, and recipe content if the command does not show content for the UAN product version that was installed.

        A STATUS of Completed indicates that the Kubernetes jobs completed successfully.

        ```bash
        ncn-m001# kubectl get pods -n services -l job-name=uan-config-import-@product_version@
        NAME                             READY   STATUS      RESTARTS   AGE
        uan-config-import-@product_version@-gsvrc   0/3     Completed   0          5m
        ncn-m001# kubectl get pods -n services -l job-name=uan-image-recipe-import-@product_version@
        NAME                                   READY   STATUS      RESTARTS   AGE
        uan-image-recipe-import-@product_version@-2fvr7   0/3     Completed   0          6m
        ```

4. Verify that the UAN RPM repositories have been created in Nexus using either of the following methods:

    - Navigate to https://nexus.CRAY\_EX\_DOMAIN/\#browse/browse in a web browser to view the list of repositories. Ensure that the following repositories are present:
        - uan-2.0.0-sle-15sp1
        - uan-2.0-sle-15sp1
    - Query Nexus through its REST API to display the repositories prefixed with the name uan:

        ```bash
        ncn-m001# curl -s -k https://packages.local/service/rest/v1/repositories | jq -r '.[] | select(.name | startswith("uan")) | .name'
        uan-2.0-sle-15sp1
        uan-2.0.0-sle-15sp1
        ```

5. Finish the typescript file started at the beginning of this procedure.

    ```bash
    # exit
    ```

Perform [Apply UAN Upgrade Patch](Apply_UAN_Upgrade_Patch.md)
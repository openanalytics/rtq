
createMultiBranchPipeline(jc,
    name = "rtq",
    branchSource = gitBranchSource(
        "https://scm.openanalytics.eu/scm/git/rtq.git",
        "jenkins-oa"))

# branch name filters are not supported yet in rjenkins (#18500)

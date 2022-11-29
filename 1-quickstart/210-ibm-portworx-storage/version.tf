terraform {
  required_providers {
    gitops = {
      source = "cloud-native-toolkit/gitops"
      version = "0.11.1"
    }

    ibm = {
      source = "ibm-cloud/ibm"
      version = "1.47.1"
    }

  }
}
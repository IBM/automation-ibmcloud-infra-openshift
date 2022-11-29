terraform {
  required_providers {
    gitops = {
      source = "cloud-native-toolkit/gitops"
      version = "0.11.1"
    }

    clis = {
      source = "cloud-native-toolkit/clis"
      version = "0.2.4"
    }

  }
}
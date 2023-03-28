resource "nobl9_service" "this" {
  name         = "ekg-${replace(lower(var.cluster_id), " ", "-")}"
  project      = var.project_name
  display_name = "${var.ekg_display_prefix}${var.cluster_id}"
  description  = "Essential Kubernetes Gauges for cluster ${var.cluster_id} -- maintain via terraform"

  label {
    key    = "cluster"
    values = [var.cluster_id]
  }
}

resource "nobl9_slo" "cluster-readiness" {
  count = var.enable_kuberhealthy_slos ? 1 : 0

  name             = "ekg-cluster-readiness-${replace(lower(var.cluster_id), " ", "-")}"
  display_name     = "${var.ekg_display_prefix} Cluster Readiness"
  service          = nobl9_service.this.name
  budgeting_method = "Occurrences"
  project          = var.project_name
  description      = "Measures the end-to-end ability to start workloads in the cluster. Based on kuberhealthy synthetics."

  label {
    key    = "prefab"
    values = ["ekg"]
  }

  label {
    key    = "cluster"
    values = [var.cluster_id]
  }

  time_window {
    unit       = "Day"
    count      = var.rolling_window_days
    is_rolling = true
  }

  objective {
    name         = "pod-start-lag"
    target       = var.kuberhealthy_pod_start_latency_target
    display_name = "Pod start lag"
    value        = var.kuberhealthy_pod_start_latency
    op           = "lt"

    raw_metric {
      query {
        amazon_prometheus {
          promql = <<EOT
          max(kuberhealthy_check_duration_seconds{check="ekg-monitoring/deployment"})
          EOT
        }
      }
    }
  }

  objective {
    name         = "pod-start-failure"
    target       = var.kuberhealthy_pod_start_success_target
    display_name = "Pod start failure"
    value        = 1
    op           = "gte"

    raw_metric {
      query {
        amazon_prometheus {
          promql = <<EOT
          avg((kuberhealthy_check{check="ekg-monitoring/deployment",status="1"} OR vector(0))/kuberhealthy_check{check="ekg-monitoring/deployment"})
          EOT
        }
      }
    }
  }

  indicator {
    name    = var.data_source_name
    project = var.data_source_project
  }
}

resource "nobl9_slo" "memory-headroom" {
  count = var.enable_kube_state_metrics_slos ? 1 : 0

  name             = "ekg-memory-headroom-${replace(lower(var.cluster_id), " ", "-")}"
  display_name     = "${var.ekg_display_prefix} Memory Headroom"
  service          = nobl9_service.this.name
  budgeting_method = "Occurrences"
  project          = var.project_name
  description      = "Measures the memory resources of the cluster, to ensure that it is not too tight (over-bin-packed / autoscaled up too slowly) or too loose (underutilized / autoscaled down too slowly). Based on kube-state-metrics and cAdvisor (kubelet)."

  label {
    key    = "prefab"
    values = ["ekg"]
  }

  label {
    key    = "cluster"
    values = [var.cluster_id]
  }

  time_window {
    unit       = "Day"
    count      = var.rolling_window_days
    is_rolling = true
  }

  objective {
    name         = "insufficient-headroom"
    target       = var.memory_headroom_target
    display_name = "Insufficient headroom"
    value        = var.memory_headroom_threshold
    op           = "lte"

    raw_metric {
      query {
        amazon_prometheus {
          promql = <<EOT
          sum(process_resident_memory_bytes) / sum(kube_node_status_allocatable{resource="memory"})
          EOT
        }
      }
    }
  }

  objective {
    name         = "memory-underutilized"
    target       = var.memory_utilization_target
    display_name = "Memory underutilized"
    value        = var.memory_utilization_threshold
    op           = "gte"

    raw_metric {
      query {
        amazon_prometheus {
          promql = <<EOT
          sum(process_resident_memory_bytes) / sum(kube_node_status_allocatable{resource="memory"})
          EOT
        }
      }
    }
  }

  indicator {
    name    = var.data_source_name
    project = var.data_source_project
  }
}

resource "nobl9_slo" "workload-health" {
  count = var.enable_kube_state_metrics_slos ? 1 : 0

  name             = "ekg-workload-health-${replace(lower(var.cluster_id), " ", "-")}"
  display_name     = "${var.ekg_display_prefix} Workload Health"
  service          = nobl9_service.this.name
  budgeting_method = "Occurrences"
  project          = var.project_name
  description      = "Measures the state of pods to ensure that something is running, and that not too many things are in an undesirable state. Based on kube-state-metrics."

  label {
    key    = "prefab"
    values = ["ekg"]
  }

  label {
    key    = "cluster"
    values = [var.cluster_id]
  }

  time_window {
    unit       = "Day"
    count      = var.rolling_window_days
    is_rolling = true
  }

  objective {
    name         = "not-enough-running"
    target       = var.phase_running_target
    display_name = "Not enough running"
    value        = var.phase_running_threshold
    op           = "gte"

    raw_metric {
      query {
        amazon_prometheus {
          promql = <<EOT
          avg(kube_pod_status_phase{phase="Running"})
          EOT
        }
      }
    }
  }

  objective {
    name         = "pods-in-bad-state"
    target       = var.phase_failed_unknown_target
    display_name = "Pods in bad state"
    value        = var.phase_failed_unknown_threshold
    op           = "lte"

    raw_metric {
      query {
        amazon_prometheus {
          promql = <<EOT
          sum(kube_pod_status_phase{phase=~"Failed|Unknown"})
          EOT
        }
      }
    }
  }

  objective {
    name         = "pods-pending"
    target       = var.phase_pending_target
    display_name = "Pods pending"
    value        = var.phase_pending_threshold
    op           = "lte"

    raw_metric {
      query {
        amazon_prometheus {
          promql = <<EOT
          sum(kube_pod_status_phase{phase="Pending"})
          EOT
        }
      }
    }
  }

  indicator {
    name    = var.data_source_name
    project = var.data_source_project
  }
}

resource "nobl9_slo" "control-plane-health" {
  name             = "ekg-control-plane-health-${replace(lower(var.cluster_id), " ", "-")}"
  display_name     = "${var.ekg_display_prefix} Control Plane Health"
  service          = nobl9_service.this.name
  budgeting_method = "Occurrences"
  project          = var.project_name
  description      = "Measures the error rate and performance of the Kubernetes API. Based on apiserver metrics."

  label {
    key    = "prefab"
    values = ["ekg"]
  }

  label {
    key    = "cluster"
    values = [var.cluster_id]
  }

  time_window {
    unit       = "Day"
    count      = var.rolling_window_days
    is_rolling = true
  }

  objective {
    name         = "high-error-rate"
    target       = var.api_error_rate_target
    display_name = "High error rate"
    value        = 0 # required field (dummy value)

    count_metrics {
      good {
        amazon_prometheus {
          promql = <<EOT
          sum(apiserver_request_total{job="kubernetes-apiservers"}) - (sum(apiserver_request_terminations_total{job="kubernetes-apiservers"}) + sum(apiserver_request_total{job="kubernetes-apiservers", code=~"5.."}))
          EOT
        }
      }
      total {
        amazon_prometheus {
          promql = <<EOT
          sum(apiserver_request_total{job="kubernetes-apiservers"})
          EOT
        }
      }
      incremental = true
    }
  }

  objective {
    name         = "slow-response-time"
    target       = var.api_latency_target
    display_name = "Slow response time"
    value        = 1 # required field (dummy value)

    count_metrics {
      good {
        amazon_prometheus {
          promql = <<EOT
          sum(apiserver_request_slo_duration_seconds_bucket{job="kubernetes-apiservers",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le="1"})
          EOT
        }
      }
      total {
        amazon_prometheus {
          promql = <<EOT
          sum(apiserver_request_slo_duration_seconds_count{job="kubernetes-apiservers",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"})
          EOT
        }
      }
      incremental = true
    }
  }

  indicator {
    name    = var.data_source_name
    project = var.data_source_project
  }
}

resource "nobl9_slo" "node-health" {
  count = (var.enable_kube_state_metrics_slos && var.enable_node_problem_detector_slos) ? 1 : 0

  name             = "ekg-node-health-${replace(lower(var.cluster_id), " ", "-")}"
  display_name     = "${var.ekg_display_prefix} Node Health"
  service          = nobl9_service.this.name
  budgeting_method = "Occurrences"
  project          = var.project_name
  description      = "Measures the issues and problems with cluster nodes. Based on kube-state-metrics and node-problem-detector."

  label {
    key    = "prefab"
    values = ["ekg"]
  }

  label {
    key    = "cluster"
    values = [var.cluster_id]
  }

  time_window {
    unit       = "Day"
    count      = var.rolling_window_days
    is_rolling = true
  }

  objective {
    name         = "node-problem-detected"
    target       = var.node_problem_target
    display_name = "Node problem detected"
    value        = var.node_problem_threshold
    op           = "lt"

    raw_metric {
      query {
        amazon_prometheus {
          promql = <<EOT
          sum(rate(problem_counter[1m]))
          EOT
        }
      }
    }
  }

  objective {
    name         = "node-not-ready"
    target       = var.node_not_ready_target
    display_name = "Node not ready"
    value        = var.node_not_ready_threshold
    op           = "lte"

    raw_metric {
      query {
        amazon_prometheus {
          promql = <<EOT
          sum(kube_node_status_condition{condition="Ready",status="false"})
          EOT
        }
      }
    }
  }

  indicator {
    name    = var.data_source_name
    project = var.data_source_project
  }
}

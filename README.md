# copilot-metrics-csv-exporter
GitHub Copilot Metrics CSV Exporter

## Usage

This script will generate CSV files for the GitHub Copilot Usage Metrics API

### Organization Metrics

Generate total usage metrics for a specific organization

```bash
sh total-org.sh <organization_name>
```

Generate usage metrics per language for a specific organization

```bash
sh per-language-org.sh <organization_name>
```

### Enterprise Metrics

Generate total usage metrics for a specific enterprise

```bash
sh total-ent.sh <enterprise_name>
```

Generate usage metrics per language for a specific enterprise

```bash
sh per-language-ent.sh <enterprise_name>
```
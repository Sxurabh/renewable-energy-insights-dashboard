# curate_data.R
# 1) Put the original OWID energy CSV at raw/owid-energy.csv
# 2) Run this script once to create a compact dataset for the app

df <- read.csv("raw/owid-energy.csv", stringsAsFactors = FALSE)

# Choose the primary energy renewables share indicator; adjust if using electricity share
keep <- c("country", "Year", "renewables_share_energy")
out <- df[keep]
out <- subset(out, !is.na(renewables_share_energy) & Year >= 1990)
write.csv(out, "data/renewables.csv", row.names = FALSE)


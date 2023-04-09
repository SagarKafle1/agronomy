
#' Calculate fertilizer dose for a given crop
#'
#'
#' @description This function calculates the amount of nitrogen, phosphate, and potash fertilizers required for a given crop based on the recommended rate of fertilizer usage. It supports different fertilizer sources including complete,muriate of potash, Diammonium Phosphate (DAP), Triple Super Phosphate (TSP), Single Super Phosphate (SSP),and Urea.
#'
#' @param nitrogen Numeric, the recommended rate of Nitrogen in Kg/Ha(Kilogram per hectare) required for a crop.
#' @param phosphorus Numeric, the recommended rate of Phosphorous in Kg/Ha(Kilogram per hectare) required for a crop.
#' @param potassium Numeric, the recommended rate of Potassium in Kg/Ha(Kilogram per hectare) required for a crop.
#' @param area Numeric, the area of the land (in hectares) where the crop will be grown. Area is assumed to be 1 hectare by default
#' @param DAP Logical, whether DAP is to be used as a source of phosphate and nitrogen or not. DAP is assumed to be FALSE by default
#' @param TSP Logical, whether TSP is to be used as a source of phosphate or not. TSP is assumed to be FALSE by default
#' @param complete Logical, whether complete(NPK mix) is to be used as fertilizers (NPK) or not. Complete is assumed to be FALSE by default
#'
#' @return A numeric vector with the amount of urea, DAP, TSP, SSP, and muriate of potash (in kg) required for the crop.
#' @export
#'
#' @examples
#' # Calculate fertilizer dose using Urea, SSP and Muriate of potash for 1 hectare of cultivation area.
#' fertilizer.dose(120,60,60)
#'
#' # Calculate fertilizer dose using Urea, SSP and Muriate of potash for 2 hectare of cultivation area.
#' fertilizer.dose(120,60,60, 2)
#'
#' # Calculate fertilizer dose using DAP as a source of phosphorus and nitrogen.
#' fertilizer.dose(nitrogen = 100, phosphorus = 50, potassium = 75, area = 2, DAP = TRUE)
#'
#' # Calculate fertilizer dose using TSP as a source of phosphorus.
#' fertilizer.dose(nitrogen = 100, phosphorus = 50, potassium = 75, area = 2, TSP = TRUE)
#'
#' # Calculate fertilizer dose using a complete fertilizer.
#' fertilizer.dose(nitrogen = 100, phosphorus = 50, potassium = 75, area = 2, complete = TRUE)
#'

fertilizer.dose <- function(nitrogen, phosphorus, potassium, area = 1, DAP = FALSE, TSP = FALSE, complete = FALSE) {
  # Check inputs
  if (!is.numeric(nitrogen) || !is.numeric(phosphorus) || !is.numeric(potassium) || !is.numeric(area)) {
    stop("Nitrogen, phosphorus, potassium, and area must be numeric.")
  }
  if (!is.logical(DAP) || !is.logical(TSP) || !is.logical(complete)) {
    stop("DAP, TSP, and complete must be logical.")
  }
  stopifnot(nitrogen >= 0, phosphorus >=0, potassium >=0, area > 0)

  # Calculate fertilizer if dap(Diammonium Phosphate) is supplied as a source of phosphorous and nitrogen fertilizer
  if (DAP && !TSP && !complete) {
    DAP_amount <- (phosphorus * 100 * area) / 46
    nitrogen_from_DAP <- DAP_amount * 18 / 100
    recommended_nitrogen <- nitrogen - nitrogen_from_DAP
    MOP_amount <- (potassium * 100 * area) / 60
  # when DAP supplies total amount of nitrogen then following message will be shown)
    if (recommended_nitrogen <= 0) {
      return(c(DAP = round(DAP_amount, 2), NsuppliedbyDAP = round(nitrogen_from_DAP, 2), MOP_amount = round(MOP_amount, 2), message = "All nitrogen will be supplied by DAP"))
    } else {
      urea_amount <- (recommended_nitrogen * 100 * area) / 46
      return(c(Urea = round(urea_amount, 2), DAP = round(DAP_amount,2) , Muriateofpotash = round(MOP_amount,2), NsuppliedbyDAP = round(nitrogen_from_DAP,2)))
    }
  }

  #Calculate fertilizer if tsp(Triple super Phosphate) is used as a source of phosphorous fertilizer
  else if (!DAP && TSP && !complete) {
    urea_amount <- (nitrogen * 100 * area) / 46
    TSP_amount <- (phosphorus * 100 * area) / 48
    MOP_amount <- (potassium * 100 * area) / 60
    return(c(Urea = round(urea_amount, 2), TSP = round(TSP_amount, 2), Muriateofpotash = round(MOP_amount, 2)))
  }

  #calculate fertilizer if urea and ssp(Single Super Phosphate) is used as fertilizer
  else if (!DAP && !TSP && !complete) {
    urea_amount <- (nitrogen * 100 * area) / 46
    SSP_amount <- (phosphorus * 100 * area) / 16
    MOP_amount <- (potassium * 100 * area) / 60
    return(c(Urea = round(urea_amount, 2), SSP = round(SSP_amount, 2), Muriateofpotash = round(MOP_amount, 2)))
  }

  #Following condition have more than one fertilizers for a single nutrients, so the calculation is stopped.
  else if (DAP && TSP && complete) {
    stop("Choose only one source of phosphate and nitrogen fertilizer.")
  }

  else if (DAP && TSP && !complete) {
    stop("Choose only one source of phosphate fertilizer.")
  }

  else if (DAP && !TSP && complete) {
    stop("Choose only one source of nitrogen and phosphate fertilizer.")
  }

  else if (!DAP && TSP && complete) {
    stop("Choose only one source of phosphate fertilizer.")
  }

  #Calculate the dose of fertilizer when complete fertilizer is used.
  else {
    nutrient_amounts <- c((nitrogen * 100 * area) / 19, (phosphorus * 100 * area) / 19, (potassium * 100 * area) / 10)
    max_index <- which.max(nutrient_amounts)
    max_amount <- nutrient_amounts[max_index]
    return(paste("The amount of complete fertilizer required is", round(max_amount, 2)))
  }
}

#' Function to calculate the seed rate and plant population for a given crop
#'
#' @description this function calculates the seed rate and plant population required for a given field area, based on the total seed weight (TSW), row spacing, plant spacing, germination rate, purity rate, and desired number of plants per hill.
#'
#'
#' @param area Numeric, the area to be sown in hectares(ha).
#' @param TSW Numeric, the thousand seed weight in gram(gm) of a given plant.
#' @param row_spacing Numeric, the spacing between rows in centimeter(cm).
#' @param plant_spacing Numeric, the spacing between Plants in centimeter(cm).
#' @param germination Numeric, the germination rate of the seed in percentage, 100 percent germination is considered by default.
#' @param purity Numeric, the purity rate of the seed in percentage, 100 percent purity is considered by default.
#' @param plant_per_hill Numeric, the desired number of plants per hill, one plant per hill is considered by default.
#' @param gap_filling Numeric, the percentage of seed required for gap filling.
#'
#' @return A string with the calculated seed rate and plant population.
#' @export
#'
#' @examples
#' # Calculation of seed rate when area, TSW, row_spacing, plant_spacing, germination, and purity is given.
#'seed.rate(1, 75, 60,30, 90, 85)
#'
#' # Calculation of seed rate when two seeds are sown per hills.
#'seed.rate(area = 2, TSW = 76, row_spacing = 60, plant_spacing = 30, germination = 96, purity = 95, plant_per_hill = 2)
#'
#' # Calculation of seed rate when shelling is 80% and gap filling is 10%.
#'seed.rate(area = 1, TSW = 90, row_spacing = 75, plant_spacing = 25, germination = 95, purity = 95, plant_per_hill = 1, gap_filling=10)
#'
seed.rate <- function(area = 1, TSW, row_spacing, plant_spacing, germination = 100, purity = 100, plant_per_hill = 1, gap_filling = 0) {

  # Validate input
  stopifnot(area > 0, TSW > 0, row_spacing > 0, plant_spacing > 0, germination >= 0, germination <= 100,
            purity >= 0, purity <= 100, plant_per_hill > 0,
            gap_filling >= 0, gap_filling <= 100)

  # plant population calculation (10,000 is the number of square meters in a hectare)
  square_meter_per_hectare <- 10000
  grams_per_kilogram <- 1000
  spacing <- (row_spacing * plant_spacing) / square_meter_per_hectare
  area_in_m2 <- (area * square_meter_per_hectare)
  plant_population <- (area_in_m2 / spacing)
  # Calculation of seed rate when gap filling is not done.
  if (gap_filling == 0) {
    seed_rate <- (area_in_m2 * TSW * 10 * plant_per_hill) / (germination * purity * spacing * grams_per_kilogram)
    return(paste("The required seed rate is", round(seed_rate, 2), "per", area, "ha and the plant population is", round(plant_population, 2), "per ha"))
  }

  # Calculation of seed rate when gap filling is done.
  else {
    seed_rate <- (area_in_m2 * TSW * 10 * plant_per_hill) / (germination * purity * spacing * grams_per_kilogram)
    gap_filling_rate <- seed_rate + (gap_filling * seed_rate / 100)
    return(paste("The required seed is", round(gap_filling_rate, 2), "per", area, "ha and the plant population is", round(plant_population), "per ha"))
  }

}

#' Function to calculate the herbicide rate to be applied for a given crop
#'
#' @description Calculates the required amount of herbicide for a given area, based on the recommended rate and active ingredients.
#'
#'
#' @param recommended_rate Numeric, the recommended rate of herbicide application in Kg/Liter a.i. per ha (Kilogram active ingredients per hectare).
#' @param area Numeric, the area of the ground to be sprayed by the herbicide in hectares(ha).
#' @param active_ingredients Numeric, the percentage of active ingredients in percentage.
#'
#' @return The required amount of herbicide in liters for the given area.
#' @export
#'
#' @examples
#' #calculate the herbicide when 2 kilogram active ingredients per hectare is recommended for one hectare of land with 35 % active ingredients)
#' herbicide.rate(2, 1, 35)
herbicide.rate<- function(recommended_rate, area = 1, active_ingredients) {
  herbicide <- recommended_rate * 100 * area/active_ingredients
  return(paste("The required amount of herbicide is", round(herbicide,2), " liter/Kg for", area, "ha"))
}












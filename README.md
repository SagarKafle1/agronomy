
<!-- README.md is generated from README.Rmd. Please edit that file -->

# agronomy

The agronomy package provides a simple and efficient way to calculate
the recommended doses of nitrogen, phosphorus, and potassium fertilizers
for a given area of farmland, seed rate for sowing in a particular area,
and the required amount of herbicides to be applied for a given area.
This package is particularly useful for students who want to determine
the required rate of fertilizers, seeds, and herbicides and farm
companies who want to maximize their crop yields while minimizing the
amount of fertilizers, seed and herbicides.

The goal of agronomy is to calculate fertilizer dose, seed rate and
herbicide application rate.

## Installation

You can install the development version of agronomy like so:

``` r
devtools:: install_github('SagarKafle1/agronomy')
```

**Here are the functions that are provided in the Agronomy package**

### 1. fertilizer.dose

fertilizer.dose is used to calculates the amount of nitrogen, phosphate,
and potash fertilizers required for a given crop based on the
recommended rate of fertilizer usage. It supports different fertilizer
sources including complete, muriate of potash, Diammonium Phosphate
(DAP), Triple Super Phosphate (TSP), Single Super Phosphate (SSP),and
Urea.

##### Example a: Basic Usage

To calculate the recommended doses of nitrogen, phosphorus, and
potassium fertilizers for a given area of farmland, you can use the
fertilizer.dose() function. For example, if you have a farmland of 2
acres and you want to apply 60 pounds of nitrogen, 30 pounds of
phosphorus, and 40 pounds of potassium per acre, you can use the
following code:

``` {r
fertilizer.dose(nitrogen = 60, phosphorus = 30, pottasium = 40, area = 2)
```

This will return a vector with the recommended doses of urea, single
super phosphate, and muriate of potash fertilizers.

#### Example b: Using DAP and TSP Fertilizers

If you want to use di-ammonium phosphate (DAP) and triple super
phosphate (TSP) fertilizers instead of single super phosphate (SSP)
fertilizer, you can use the DAP and TSP arguments. For example, if you
want to use DAP as a source of phosphorus fertilizer then use can use:

``` {r
fertilizer.dose(nitrogen = 60, phosphorus = 0, potassium = 40, area = 2, DAP = TRUE)
```

This will return a vector with the recommended doses of urea, DAP, and
muriate of potash fertilizers, as well as the amount of nitrogen
supplied by the DAP fertilizer.

if you want to use TSP as a source of phosphorus fertilizer then you can
use:

``` {r
fertilizer.dose(nitrogen = 60, phosphorus = 0, potassium = 40, area = 2, TSP = TRUE)
```

This will return a vector with the recommended doses of urea, TSP, and
muriate of potash fertilizers, as well as the amount of nitrogen
supplied by the DAP fertilizer.

> **Note: You cannot use more than one source of phosphorus fertilizer**

#### Example c: Using Complete Fertilizers

If you want to use a complete fertilizer that contains nitrogen,
phosphorus, and potassium, you can use the complete argument. For
example, if you want to use a complete fertilizer with 19% nitrogen, 19%
phosphorus, and 10% potassium, you can use the following code:

``` {r
fertilizer.dose(nitrogen = 60, phosphorus = 30, potassium = 40, area = 2, complete = TRUE)
```

This will return a vector with the recommended doses complete as well as
the amount of nitrogen supplied by the DAP fertilizer.

### 2. seed.rate

seed rate function is used to calculate the seed rate and plant
population required for a given field area, based on the total seed
weight (TSW), row spacing, plant spacing, germination rate, purity rate,
and desired number of plants per hill.

### Example a: Basic usage

You can call the seed.rate() function by providing the input parameters
without gap filling. The default values for area, germination, purity,
plant_per_hill, shelling, and gap_filling are 1 ha, 100% , 100% , 1, 0,
and 0% respectively. If you want to calculate seed rate for 2 hectares
of land with thousand seed weight(TSW) of 76gm, germination(90%),
purity(96%), row spacing of 60cm, and plant spacing of 25cm, you can use
the following code:

``` {r
seed.rate(area= 2, TSW = 76, row_spacing = 60, plant_spacing = 25, germination = 90, purity = 96)
```

This will return a string with the calculated seed rate and plant
population.

### Example b: When gap filling is provided:

you can also call the function seed rate when certain percentage of seed
is necessary for gap filling due to unexpected damage during intial
sowing. Gap filling can be required when some seeds do not germinate or
germinated seedling get damaged by disease, pests, or other mechanical
factors. If you want to use extra 10% seed for gap filling then you can
use the following code:

``` {r
seed.rate(area= 2, TSW = 76, row_spacing = 60, plant_spacing = 25, germination = 90, purity = 96, gap_filling =10)
```

This will return a string with the calculated seed rate and plant
population

### 3. herbicide.rate

When applying herbicides, it is important to determine the correct
amount of herbicide required to cover the target area.This function is
used to calculate the required amount of herbicide for a given area,
based on the recommended rate and active ingredients.

### Example a: Basic usage

We can calculate the required amount of herbicides in liters, provided
that area is 2 hectare, recommended rate of 2 L/ha and 50% active
ingredients, using the following code:

``` {r
herbicide.rate(area = 2, recommended_rate = 2, active_ingredients = 50)
```

This will return a string with the calculated amount of herbicide
required for a given hectare of land.

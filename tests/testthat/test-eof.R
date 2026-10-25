
test_that("the eof function works", {
	chla1 <- aggregate(sfbayChla, 1, mean, na.rm = TRUE)
	chla1 <- chla1[, 1:12]  # remove stations with missing years
	expect_false(identical(eof(chla1, 1, FALSE), eof(chla1, 1, TRUE)))
})


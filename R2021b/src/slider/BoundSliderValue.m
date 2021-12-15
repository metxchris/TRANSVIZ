function sliderValue = BoundSliderValue(option)
% bounds slider value 
sliderValue = min(option.slider.value, option.slider.max);
sliderValue = max(sliderValue, option.slider.min);
sliderValue = double(sliderValue);

end

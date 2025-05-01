import React from 'react';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';

interface DateRangePickerProps {
  startDate: Date;
  endDate: Date;
  onStartDateChange: (date: Date | null) => void;
  onEndDateChange: (date: Date | null) => void;
}

const DateRangePicker: React.FC<DateRangePickerProps> = ({ startDate, endDate, onStartDateChange, onEndDateChange }) => {
  return (
    <div className="flex items-center space-x-4">
      <div className="flex items-center">
        <label className="font-medium text-lg">Início:</label>
        <DatePicker
          selected={startDate}
          onChange={(date) => date && onStartDateChange(date)}
          className="p-2 border border-gray-300 rounded-md"
          dateFormat="yyyy-MM-dd"
        />
      </div>
      <div className="flex items-center">
        <label className="font-medium text-lg">Fim:</label>
        <DatePicker
          selected={endDate}
          onChange={(date) => date && onEndDateChange(date)}
          className="p-2 border border-gray-300 rounded-md"
          dateFormat="yyyy-MM-dd"
        />
      </div>
    </div>
  );
};

export default DateRangePicker;

'use client';

import React from 'react';
import classNames from 'classnames';

interface CustomButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  bgColor?: string;
  textColor?: string;
  className?: string;
  type?: 'button' | 'submit' | 'reset';
}

const CustomButton = ({
  children,
  onClick,
  bgColor = 'bg-white',
  textColor = 'text-orange-600',
  className = '',
  type = 'button',
}: CustomButtonProps) => {
  return (
    <button
      type={type}
      onClick={onClick}
      className={classNames(
        'w-full py-2 px-4 rounded font-semibold transition hover:bg-gray-100 cursor-pointer',
        bgColor,
        textColor,
        className
      )}
    >
      {children}
    </button>
  );
};

export default CustomButton;

#!/usr/bin/env python
# -*- coding: utf-8 -*-

from math import log as ln
from random import random, randint


def d_uniforme(a=0.0, b=0.0):
    return random()*(b - a) + a


def d_exp(tasa):
    return -ln(random()) / tasa


def d_normal(media, desvio, n=12):
    val = -6.0
    for i in range(n):
        val += random()
    return val * desvio + media


def d_entero(a=0, b=0):
    """
        Retorna un numero aleatorio entero entre a y b
    """
    return randint(a, b)

# -*- coding: utf-8 -*-
from zope.interface import Attribute, Interface
from properties import IPropertiesTool
from basetool import IPloneBaseTool
from basetool import IPloneTool
from basetool import IPloneCatalogTool
from controlpanel import IControlPanel
from interface import IInterfaceTool
from migration import IMigrationTool
from factory import IFactoryTool
from translationservice import ITranslationServiceTool


#
#   Registration tool interface
#
class IRegistrationTool(Interface):

    """ Manage policies for member registration.

    o Depends on IMembershipTool component.

    o Is not aware of membership storage details.
    """

    id = Attribute('id',
            """ The ID of the tool.

            o BBB:  for use in 'getToolByName';  in the future, prefer
              'zapi.getUtility(IRegistrationTool)'.

            o Must be set to "portal_registration"
            """,
            )

    def isRegistrationAllowed(REQUEST):
        """ Return True if the current user is allowed to add a member to
            the site, else False.

        o Permission:  Public
        """

    def testPasswordValidity(password, confirm=None):
        """ Return None if the password is valid;  otherwise return a string
            explaining why not.

        o 'password' is the candidate password string.

        o If 'confirm' is passed, XXX?

        o Permission:  Public
        """

    def testPropertiesValidity(new_properties, member=None):
        """ Return None if the supplied properties are valid;  otherwise
            return a string explaining why not.

        o 'new_properties' is a mapping containing the properties to test.

        o 'member', if passed, is the ID of the member for whome the
          properties are being set;  if not passed, use the currently-
          authenticated member.

        o Permission:  Public
        """

    def generatePassword():
        """ Return a generated password which is complies with the site's
            password policy.

        o Permission:  Public
        """

    def addMember(id, password, roles=('Member',), domains='',
                  properties=None):
        """ Creates and return a new member.

        o 'id' is the user ID of the member to be created;  raise ValueError
          if there already exists a member with the given 'id'.

        o 'password' is the user's password;  raise ValueError if the
          supplied 'password' does not comply with the site's password policy.

        o 'roles' is a list of roles to grant the new member;  raise
          Unauthorized if the currently-authenticated user is not
          allowed to grant one of the roles listed

          - "Member" is a special role that can always be granted

        o 'properties', if passed,  is a mapping with additional member
          properties;  raise ValueError if one or more properties do not
          comply with the site's policies.

        o Permission:  Add portal member
        """

    def isMemberIdAllowed(id):
        """ Return True if 'id' is not in use as a member ID and is not
            reserved, else False.

        o Permission:  Add portal member
        """

    def afterAdd(member, id, password, properties):
        """ Notification called by portal_registration.addMember() after a
            member has been added successfully.

        o Permission:  Private (Python only)
        """

    def mailPassword(forgotten_userid, REQUEST):
        """ Email a forgotten password to a member.

        o Raise ValueError if user ID is not found.

        o XXX: should probably *not* raise, in order to prevent cracking.

        o Permission:  Mail forgotten password
        """
